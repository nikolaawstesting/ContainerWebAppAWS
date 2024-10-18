variable "project_name" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "region" {
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

###########################################################################
###########################################################################

resource "aws_vpc" "timethief-vpc-01" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.environment}-${var.project_name}-vpc-1"
  }
}


resource "aws_subnet" "timethief-subnet-public-01" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.timethief-vpc-01.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.environment}-${var.project_name}-public-0${count.index+1}"
  }
}


resource "aws_subnet" "timethief-subnet-private-01" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.timethief-vpc-01.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.environment}-${var.project_name}-private-0${count.index+1}"
  }
}


resource "aws_internet_gateway" "timethief-ig-01" {
  vpc_id = aws_vpc.timethief-vpc-01.id
  tags = {
    Name = "${var.environment}-${var.project_name}-ig-01"
  }
}


resource "aws_route_table" "timethief-rt-public-01" {
  vpc_id = aws_vpc.timethief-vpc-01.id
   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.timethief-ig-01.id
    }
    tags = {
    Name = "${var.environment}-${var.project_name}-rt-public-01"
    }
}


resource "aws_route_table_association" "timethief-assoc-public-01" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.timethief-subnet-public-01[count.index].id
  route_table_id = aws_route_table.timethief-rt-public-01.id
}



output "vpc_id" {
  value = aws_vpc.timethief-vpc-01.id
}

output "public_subnet_ids" {
  value = aws_subnet.timethief-subnet-public-01[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.timethief-subnet-private-01[*].id
}

output "public_route_table_id" {
  value = aws_route_table.timethief-rt-public-01.id
}

output "default_route_table_id" {
  value = aws_vpc.timethief-vpc-01.default_route_table_id
}


