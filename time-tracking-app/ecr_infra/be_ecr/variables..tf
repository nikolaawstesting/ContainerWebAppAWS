variable "project_name" {
    description = "The name of the project"
    type        = string
    default     = "timethief"
}

variable "environment" {
    description = "The environment to deploy resources in"
    type        = string
    default     = "dev"
}

variable "region" {
    description = "The AWS region to deploy resources in"
    type        = string
    default     = "eu-west-1"
}

variable "aws_account_id" {
  description = "Target AWS Account ID"
  type        = string
}

variable "assume_role_arn" {
  description = "The ARN of the role to assume"
  type        = string
  default     = "arn:aws:iam::054037132472:role/github-actions-role"
}