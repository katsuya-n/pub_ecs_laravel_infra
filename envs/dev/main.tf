provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Env    = "dev"
      System = local.name_prefix
      Owner  = "lightkun"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.42.0"
    }
  }
  required_version = "1.0.9"
  backend "s3" {
    bucket = "lightkun-ecs-laravel-pj-terraform-tfstate-20220108-us-east-1"
    key    = "dev.tfstate"
    region = "us-east-1"
  }
}

module "vpc" {
  source      = "../../modules/network/vpc"
  name_prefix = local.name_prefix
  vpc_cidr    = local.vpc_cidr
}

module "public_subnet" {
  source                   = "../../modules/network/public_subnet"
  name_prefix              = local.name_prefix
  alb_subnet_cidr_block_1a = local.alb_subnet_cidr_block_1a
  alb_subnet_cidr_block_1b = local.alb_subnet_cidr_block_1b
  subnet_az_1a             = local.az_1a
  subnet_az_1b             = local.az_1b
  vpc_id                   = module.vpc.vpc_id
}

module "private_subnet" {
  source                         = "../../modules/network/private_subnet"
  name_prefix                    = local.name_prefix
  container_subnet_cidr_block_1a = local.container_subnet_cidr_block_1a
  container_subnet_cidr_block_1b = local.container_subnet_cidr_block_1b
  subnet_az_1a                   = local.az_1a
  subnet_az_1b                   = local.az_1b
  vpc_id                         = module.vpc.vpc_id
}