variable "project_name" {
  type        = string
}

variable "region" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "vpc_cidr" {
  type        = string
}

variable "public_subnet_cidrs" {
  type        = list(string)
}

variable "private_subnet_cidrs" {
  type        = list(string)
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.environment}-${var.project_name}-vpc-1"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.environment}-${var.project_name}-public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.environment}-${var.project_name}-private-${count.index}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.environment}-${var.project_name}-ig"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
    }
    tags = {
    Name = "${var.environment}-${var.project_name}-public-rt"
    }
}

resource "aws_route_table_association" "public_association" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}



resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"
 vpc_endpoint_type = "Gateway"
 route_table_ids = [aws_route_table.public.id, aws_route_table.private.id]
 policy = data.aws_iam_policy_document.s3_ecr_access.json

}


resource "aws_vpc_endpoint" "ecr-dkr-endpoint" {
  vpc_id       = aws_vpc.main.id
 private_dns_enabled = true
  service_name = "com.amazonaws.${var.region}.ecr.dkr"
 vpc_endpoint_type = "Interface"
 subnet_ids = "${aws_subnet.private.*.id}, ${aws_subnet.public.*.id}"

}

resource "aws_vpc_endpoint" "ecr-api-endpoint" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.ecr.api"
 vpc_endpoint_type = "Interface"
 private_dns_enabled = true
  subnet_ids = "${aws_subnet.private.*.id}, ${aws_subnet.public.*.id}"
}
resource "aws_vpc_endpoint" "ecs-agent" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.ecs-agent"
 vpc_endpoint_type = "Interface"
 private_dns_enabled = true
 subnet_ids = "${aws_subnet.private.*.id}, ${aws_subnet.public.*.id}"


}
resource "aws_vpc_endpoint" "ecs-telemetry" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.ecs-telemetry"
 vpc_endpoint_type = "Interface"
 private_dns_enabled = true
 subnet_ids = "${aws_subnet.private.*.id}, ${aws_subnet.public.*.id}"

}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "security_group_id" {
  value = aws_security_group.ecs.id
}


