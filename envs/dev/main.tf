variable "allow_cidr_block" {}

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
  vpce_subnet_cidr_block_1a      = local.vpce_subnet_cidr_block_1a
  vpce_subnet_cidr_block_1b      = local.vpce_subnet_cidr_block_1b
  rds_subnet_cidr_block_1a       = local.rds_subnet_cidr_block_1a
  rds_subnet_cidr_block_1b       = local.rds_subnet_cidr_block_1b
  subnet_az_1a                   = local.az_1a
  subnet_az_1b                   = local.az_1b
  vpc_id                         = module.vpc.vpc_id
}

module "sg" {
  source           = "../../modules/network/sg"
  name_prefix      = local.name_prefix
  vpc_id           = module.vpc.vpc_id
  allow_cidr_block = var.allow_cidr_block
}

module "route_table" {
  source       = "../../modules/network/route_table"
  name_prefix  = local.name_prefix
  vpc_id       = module.vpc.vpc_id
  subnet_1a_id = module.private_subnet.subnet_container_1a_id
  subnet_1b_id = module.private_subnet.subnet_container_1b_id
}

module "vpc_endpoints" {
  source                    = "../../modules/network/vpc_endpoint"
  name_prefix               = local.name_prefix
  vpc_id                    = module.vpc.vpc_id
  sg_id                     = module.sg.sg_vpce_id
  subnet_1a_id              = module.private_subnet.subnet_container_1a_id
  subnet_1b_id              = module.private_subnet.subnet_container_1b_id
  route_table_private_1a_id = module.route_table.route_table_private_1a_id
  route_table_private_1b_id = module.route_table.route_table_private_1b_id
}

module "ecr" {
  source        = "../../modules/ecr"
  name_prefix   = local.name_prefix
  holding_count = 1
}