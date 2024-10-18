terraform {
  required_providers { 
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70.0"
    }
  }
  backend "s3" {
    bucket = "terraformtimethiefresources"
    region = "eu-west-1"
  }

}

provider "aws" {
  region  = var.region
}



module "networking" {
  source = "./modules/networking-module/"
  project_name = var.project_name
  environment = var.environment
  region = var.region
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "ecs" {
  source = "./modules/ecs-module/"
  project_name = var.project_name
  environment = var.environment
  region = var.region
  vpc_id = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  public_route_table_id = module.networking.public_route_table_id
  default_route_table_id = module.networking.default_route_table_id
  ecr_repository_url = var.repository_url
  certificate_arn = var.certificate_arn
  zone43_id = var.zone43_id
  repository_url = var.repository_url
  container_version = var.container_version
}