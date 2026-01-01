terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones = var.availability_zones
}

module "security_groups" {
  source = "./modules/security_groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_security_group_id = module.security_groups.db_security_group_id
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_instance_class = var.db_instance_class
  db_engine_version = var.db_engine_version
}

module "ec2" {
  source = "./modules/ec2"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  web_security_group_id = module.security_groups.web_security_group_id
  rds_endpoint = module.rds.rds_endpoint
  db_username  = var.db_username
  db_password  = var.db_password
  db_name      = var.db_name
  instance_type = var.instance_type
  key_name     = var.key_name
}