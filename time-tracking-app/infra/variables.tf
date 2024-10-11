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

variable backend_bucket_name {
    description = "The name of the S3 bucket to store the Terraform state file"
    type        = string
    default    = "terraformtimethiefresources"
}

variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/24"
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.0.32/28", "10.0.0.64/28", "10.0.0.96/28"]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.0.160/28", "10.0.0.192/28", "10.0.0.224/28"]
}

variable "certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
  default = "arn:aws:acm:eu-west-1:054037132472:certificate/55646a37-ad0f-4a47-b73b-480a863c158d"
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
  default     = "054037132472" 
}

variable "assume_role_arn" {
  description = "The ARN of the role to assume"
  type        = string
  default     = "arn:aws:iam::054037132472:role/github-actions-role"
}

variable "github_org_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "nikolaawstesting"
}

variable "github_repo_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "containerwebappaws"
}


variable "repository_url" {
  description = "The URL of the ECR repository"
  type        = string
  default     = "054037132472.dkr.ecr.eu-west-1.amazonaws.com/"
}

variable "container_version" {
  description = "The version of the container"
  type        = string
  default     = "v7"
}

variable "zone43_id" {
  description = "The Route53 zone ID"
  type        = string
  default     = "Z04273732ECIZDWHL4OEF"
}


