variable "project_name" {
    description = "The project name for the ECS resources"
    type        = string
}

variable "environment" {
    description = "The environment for the ECS resources"
    type        = string
}

variable "region" {
    description = "The AWS region"
    type        = string
}

variable "vpc_id" {
    description = "The VPC ID where the ECS cluster will be deployed"
    type        = string
}

variable "public_subnet_ids" {
    description = "The public subnet IDs where the ECS tasks will be deployed"
    type        = list(string)
}

variable "private_subnet_ids" {
    description = "The private subnet IDs where the ECS tasks will be deployed"
    type        = list(string)
}

variable "public_route_table_id" {
    description = "The route table ID for the ECS resources"
    type        = string
}

variable "default_route_table_id" {
    description = "The default route table ID for the ECS resources"
    type        = string
}

variable "ecr_repository_url" {
    description = "The URL of the ECR repository"
    type        = string
}

variable "certificate_arn" {
    description = "The ARN of the ACM certificate"
    type        = string
}

variable "zone43_id" {
    description = "The Route53 zone ID"
    type        = string
}

variable "repository_url" {
    description = "The URL of the ECR repository"
    type        = string
}

variable "container_version" {
    description = "The version of the container"
    type        = string
}

###########################################################################
###########################################################################

# resource "aws_iam_role" "timethief-task-execution-role-ecs-fe-01" {
#     name = "${var.environment}-${var.project_name}-task-execution-role-ecs-01"

#     assume_role_policy = jsonencode({
#         Version = "2012-10-17"
#         Statement = [
#             {
#                 Effect = "Allow"
#                 Principal = {
#                     Service = "ecs-tasks.amazonaws.com"
#                 }
#                 Action = "sts:AssumeRole"
#             }
#         ]
#     })

#     managed_policy_arns = [
#         "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
#     ]
# }


# resource "aws_iam_role_policy" "timethief-task-execution-policy-ecs-fe-01" {
#     name = "${var.environment}-${var.project_name}-task-execution-policy-ecs-fe-01"
#     role = aws_iam_role.timethief-task-execution-role-ecs-fe-01.id

#     policy = jsonencode({
#         Version = "2012-10-17"
#         Statement = [
#             {
#                 Effect = "Allow"
#                 Action = [
#                     "ecr:GetDownloadUrlForLayer",
#                     "ecr:BatchGetImage",
#                     "ecr:BatchCheckLayerAvailability",
#                     "logs:CreateLogGroup",
#                     "logs:CreateLogStream",
#                     "logs:PutLogEvents"
#                 ]
#                 Resource = "*"
#             }
#         ]
#     })
# }


# resource "aws_security_group" "timethief-sg-alb-fe-01" {
#     name        = "${var.environment}-${var.project_name}-sg-alb-fe-01"
#     description = "Security group for ALB/ECS frontend service"
#     vpc_id      = var.vpc_id

#     ingress {
#         from_port   = 443
#         to_port     = 443
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     egress {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
# }


# resource "aws_security_group" "timethief-ecs-service-sg-fe-01" {
#     name        = "${var.environment}-${var.project_name}-ecs-sg-fe-01"
#     description = "Security group for ECS service"
#     vpc_id      = var.vpc_id

#     ingress {
#         from_port   = 8080
#         to_port     = 8080
#         protocol    = "tcp"
#         security_groups = [aws_security_group.timethief-sg-alb-fe-01.id]
#     }

#     egress {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
# }


# resource "aws_cloudwatch_log_group" "timethief-ecs-cw-log-group-fe-01" {
#     name              = "/ecs/${var.environment}-${var.project_name}-ecs-cw-log-group-fe-01"
#     retention_in_days = 1
# }


# resource "aws_ecs_cluster" "timethief-ecs-cluster-fe-01" {
#     name = "${var.environment}-${var.project_name}-ecs-cluster-fe-01"
# }

# resource "aws_ecs_task_definition" "timethief-ecs-task-definition-fe-01" {
#     family                   = "${var.environment}-${var.project_name}-ecs-task-definition-fe-01"
#     network_mode             = "awsvpc"
#     requires_compatibilities = ["FARGATE"]
#     cpu                      = "256"
#     memory                   = "512"

#     execution_role_arn = aws_iam_role.timethief-task-execution-role-ecs-fe-01.arn

#     container_definitions = jsonencode([
#         {
#             name      = "${var.environment}-${var.project_name}-container-fe-01"
#             image     = "${ var.environment }-${ var.project_name }-ecr-fe-01:${var.container_version}"
#             essential = true
#             portMappings = [
#                 {
#                     containerPort = 8080
#                     hostPort      = 8080
#                     protocol      = "tcp"
#                 }
#             ]
#             logConfiguration = {
#                 logDriver = "awslogs"
#                 options = {
#                     "awslogs-group"         = aws_cloudwatch_log_group.timethief-ecs-cw-log-group-fe-01.name
#                     "awslogs-region"        = var.region
#                     "awslogs-stream-prefix" = "ecs-fe"
#                 }
#             }
#         }
#     ])
# }

# resource "aws_lb" "timethief-alb-fe-01" {
#     name               = "${var.environment}-${var.project_name}-alb-fe-01"
#     internal           = false
#     load_balancer_type = "application"
#     security_groups    = [aws_security_group.timethief-sg-alb-fe-01.id]
#     subnets            = var.public_subnet_ids
# }

# resource "aws_lb_target_group" "timethief-alb-tg-fe-01" {
#     name     = "${var.environment}-${var.project_name}-alb-tg-fe-01"
#     port     = 8080
#     protocol = "HTTP"
#     vpc_id   = var.vpc_id
#     target_type = "ip"


#     health_check {
#         path                = "/"
#         protocol            = "HTTP"
#         matcher             = "200"
#         interval            = 30
#         timeout             = 5
#         healthy_threshold   = 2
#         unhealthy_threshold = 2
#     }
# }

# resource "aws_lb_listener" "timethief-alb-listener-fe-01" {
#     load_balancer_arn = aws_lb.timethief-alb-fe-01.arn
#     port              = 443
#     protocol          = "HTTPS"
#     ssl_policy        = "ELBSecurityPolicy-2016-08"
#     certificate_arn   = var.certificate_arn
    

#     default_action {
#         type             = "forward"
#         target_group_arn = aws_lb_target_group.timethief-alb-tg-fe-01.arn
#     }
# }


# resource "aws_ecs_service" "timethief-ecs-service-fe-01" {
#     name            = "${var.environment}-${var.project_name}-ecs-service-fe-01"
#     cluster         = aws_ecs_cluster.timethief-ecs-cluster-fe-01.id
#     task_definition = aws_ecs_task_definition.timethief-ecs-task-definition-fe-01.arn
#     desired_count   = 1
#     launch_type     = "FARGATE"

#     network_configuration {
#         subnets         = var.public_subnet_ids
#         security_groups = [aws_security_group.timethief-ecs-service-sg-fe-01.id]
#         assign_public_ip = true
#     }

#     load_balancer {
#         target_group_arn = aws_lb_target_group.timethief-alb-tg-fe-01.arn
#         container_name   = "${var.environment}-${var.project_name}-container-fe-01"
#         container_port   = 8080
        
#     }
# }


# resource "aws_route53_record" "timethief-alb-record-fe-01" {
#   zone_id = var.zone43_id
#   name    = "www"
#   type    = "A"
#   alias {
#     name    = aws_lb.timethief-alb-fe-01.dns_name
#     zone_id = aws_lb.timethief-alb-fe-01.zone_id
#     evaluate_target_health = true
#   }
# }




resource "aws_iam_role" "timethief-ecs-task-execution-role-be-01" {
    name = "${var.environment}-${var.project_name}-ecs-task-execution-role-be-01"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })

    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    ]
}


resource "aws_iam_role_policy" "timethief-ecs-task-execution-policy-be-01" {
    name = "${var.environment}-${var.project_name}-ecs-task-execution-policy-be-01"
    role = aws_iam_role.timethief-ecs-task-execution-role-be-01.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:BatchGetImage",
                    "ecr:BatchCheckLayerAvailability",
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
                Resource = "*"
            }
        ]
    })
}



resource "aws_security_group" "timethief-sg-alb-be-01" {
    name        = "${var.environment}-${var.project_name}-sg-alb-be-01"
    description = "Security group for ALB/ECS frontend service"
    vpc_id      = var.vpc_id

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_security_group" "timethief-ecs-service-sg-be-01" {
    name        = "${var.environment}-${var.project_name}-ecs-sg-be-01"
    description = "Security group for ECS service"
    vpc_id      = var.vpc_id

    ingress {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        security_groups = [aws_security_group.timethief-sg-alb-be-01.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_cloudwatch_log_group" "timethief-ecs-cw-log-group-be-01" {
    name              = "/ecs/${var.environment}-${var.project_name}-ecs-cw-log-group-be-01"
    retention_in_days = 1
}


resource "aws_ecs_cluster" "timethief-ecs-cluster-be-01" {
    name = "${var.environment}-${var.project_name}-ecs-cluster-be-01"
}

resource "aws_ecs_task_definition" "timethief-ecs-task-definition-be-01" {
    family                   = "${var.environment}-${var.project_name}-ecs-task-definition-be-01"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = "256"
    memory                   = "512"

    execution_role_arn = aws_iam_role.timethief-task-execution-role-ecs-be-01.arn

    container_definitions = jsonencode([
        {
            name      = "${var.environment}-${var.project_name}-container-be-01"
            image     = "${ var.environment }-${ var.project_name }-ecr-be-01:${var.container_version}"
            essential = true
            portMappings = [
                {
                    containerPort = 3000
                    hostPort      = 3000
                    protocol      = "tcp"
                }
            ]
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    "awslogs-group"         = aws_cloudwatch_log_group.timethief-ecs-cw-log-group-be-01.name
                    "awslogs-region"        = var.region
                    "awslogs-stream-prefix" = "ecs-be"
                }
            }
        }
    ])
}

resource "aws_lb" "timethief-alb-be-01" {
    name               = "${var.environment}-${var.project_name}-alb-be-01"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.timethief-sg-alb-be-01.id]
    subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "timethief-alb-tg-be-01" {
    name     = "${var.environment}-${var.project_name}-alb-tg-be-01"
    port     = 3000
    protocol = "HTTP"
    vpc_id   = var.vpc_id
    target_type = "ip"


    health_check {
        path                = "/"
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }
}

resource "aws_lb_listener" "timethief-alb-listener-be-01" {
    load_balancer_arn = aws_lb.timethief-alb-be-01.arn
    port              = 443
    protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = var.certificate_arn
    

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.timethief-alb-tg-be-01.arn
    }
}


resource "aws_ecs_service" "timethief-ecs-service-be-01" {
    name            = "${var.environment}-${var.project_name}-ecs-service-be-01"
    cluster         = aws_ecs_cluster.timethief-ecs-cluster-be-01.id
    task_definition = aws_ecs_task_definition.timethief-ecs-task-definition-be-01.arn
    desired_count   = 1
    launch_type     = "FARGATE"

    network_configuration {
        subnets         = var.public_subnet_ids
        security_groups = [aws_security_group.timethief-ecs-service-sg-be-01.id]
        assign_public_ip = true
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.timethief-alb-tg-be-01.arn
        container_name   = "${var.environment}-${var.project_name}-container-be-01"
        container_port   = 3000
        
    }
}


resource "aws_route53_record" "timethief-alb-record-be-01" {
  zone_id = var.zone43_id
  name    = "www"
  type    = "A"
  alias {
    name    = aws_lb.timethief-alb-be-01.dns_name
    zone_id = aws_lb.timethief-alb-be-01.zone_id
    evaluate_target_health = true
  }
}



# resource "aws_vpc_endpoint" "s3" {
#   vpc_id       = var.vpc_id
#   service_name = "com.amazonaws.${var.region}.s3"
#  vpc_endpoint_type = "Gateway"
#  route_table_ids = [var.public_route_table_id, var.default_route_table_id]
# }


# resource "aws_vpc_endpoint" "ecr-dkr-endpoint" {
#   vpc_id       = var.vpc_id
#  private_dns_enabled = true
#   service_name = "com.amazonaws.${var.region}.ecr.dkr"
#  vpc_endpoint_type = "Interface"
#  security_group_ids = [aws_security_group.ecs_service-sg.id, aws_security_group.alb_service-sg.id]
#  subnet_ids = var.public_subnet_ids

# }

# resource "aws_vpc_endpoint" "ecr-api-endpoint" {
#   vpc_id       = var.vpc_id
#   service_name = "com.amazonaws.${var.region}.ecr.api"
#  vpc_endpoint_type = "Interface"
#  private_dns_enabled = true
#  security_group_ids = [aws_security_group.ecs_service-sg.id, aws_security_group.alb_service-sg.id]
#  subnet_ids = var.public_subnet_ids

# }
# resource "aws_vpc_endpoint" "ecs-agent" {
#   vpc_id       = var.vpc_id
#   service_name = "com.amazonaws.${var.region}.ecs-agent"
#  vpc_endpoint_type = "Interface"
#  private_dns_enabled = true
#  security_group_ids = [aws_security_group.ecs_service-sg.id, aws_security_group.alb_service-sg.id]
#  subnet_ids = var.public_subnet_ids
# }

# resource "aws_vpc_endpoint" "ecs-telemetry" {
#   vpc_id       = var.vpc_id
#   service_name = "com.amazonaws.${var.region}.ecs-telemetry"
#  vpc_endpoint_type = "Interface"
#  private_dns_enabled = true
#  security_group_ids = [aws_security_group.ecs_service-sg.b.;.id, aws_security_group.alb_service-sg.id]
#  subnet_ids = var.public_subnet_ids

# }

# resource "aws_vpc_endpoint" "logs" {
#   vpc_id       = var.vpc_id
#   service_name = "com.amazonaws.${var.region}.logs"
#  vpc_endpoint_type = "Interface"
#  private_dns_enabled = true
#  security_group_ids = [aws_security_group.ecs_service-sg.id, aws_security_group.alb_service-sg.id]
#  subnet_ids = var.public_subnet_ids

# }

output "ecs_cluster_id" {
    description = "The ID of the ECS cluster"
    value       = aws_ecs_cluster.timethief-ecs-cluster-be-01.id
}

output "ecs_service_name" {
    description = "The name of the ECS service"
    value       = aws_ecs_service.timethief-ecs-service-be-01.name
}

output "ecs_task_definition_arn" {
    description = "The ARN of the ECS task definition"
    value       = aws_ecs_task_definition.timethief-ecs-task-definition-be-01.arn
}