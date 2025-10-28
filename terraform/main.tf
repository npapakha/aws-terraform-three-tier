terraform {
  required_version = "~> 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    key          = "github.com/papahigh/aws-terraform-three-tier.tfstate"
    bucket       = "npapakha-terraform-state"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project   = var.app_name
      ManagedBy = "Terraform"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"

  name = var.app_name
  cidr = var.cidr

  region             = var.region
  availability_zones = var.availability_zones

  gateway_endpoints   = ["s3"]
  interface_endpoints = ["ecr.api", "ecr.dkr", "logs", "monitoring", "secretsmanager"]

  elb_ports = [{ port = var.elb_port, protocol = "tcp" }]
  app_ports = [{ port = var.app_port, protocol = "tcp" }]
  db_ports  = [{ port = var.db_port, protocol = "tcp" }]
}

module "rds" {
  source = "./modules/rds"

  name     = var.app_name
  username = var.db_username

  subnets         = module.vpc.db_subnets
  security_groups = module.vpc.db_security_groups

  multi_az          = var.db_multi_az
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  storage_type      = var.db_storage_type
  allocated_storage = var.db_allocated_storage

  backup_window           = var.db_backup_window
  backup_retention_period = var.db_backup_retention_period
  maintenance_window      = var.db_maintenance_window
}

module "ecr" {
  source = "./modules/ecr"

  name = var.app_name
}

module "alb" {
  source = "./modules/alb"

  name            = var.app_name
  port            = var.elb_port
  target_port     = var.app_port
  target_protocol = "HTTP"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = module.vpc.elb_security_groups
}

module "ecs" {
  source = "./modules/ecs"

  aws_ecr_url            = module.ecr.repository_url
  aws_db_secret          = module.rds.secret_arn
  aws_lb_target_group_id = module.alb.lb_target_group_arn

  subnets         = module.vpc.app_subnets
  security_groups = module.vpc.app_security_groups

  name          = var.app_name
  port          = var.app_port
  cpu           = var.app_cpu
  memory        = var.app_memory
  desired_count = var.app_desired_count
  environment = [
    {
      name  = "AWS_REGION",
      value = var.region
    },
    {
      name  = "AWS_DB_SECRET",
      value = module.rds.secret_arn
    },
    {
      name  = "PG_URL",
      value = "jdbc:postgresql://${module.rds.db_endpoint}/${module.rds.db_name}"
    },
  ]
}
