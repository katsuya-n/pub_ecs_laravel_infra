variable "allow_cidr_block" {}
data "aws_caller_identity" "current" {}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Env    = local.env
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

module "iam_role" {
  source = "../../modules/iam/iam_role"
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

module "igw" {
  source      = "../../modules/network/igw"
  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
}

module "route_table" {
  source                         = "../../modules/network/route_table"
  name_prefix                    = local.name_prefix
  vpc_id                         = module.vpc.vpc_id
  private_container_subnet_1a_id = module.private_subnet.subnet_container_1a_id
  private_container_subnet_1b_id = module.private_subnet.subnet_container_1b_id
  public_alb_subnet_1a_id        = module.public_subnet.subnet_alb_1a_id
  public_alb_subnet_1b_id        = module.public_subnet.subnet_alb_1b_id
  igw_id                         = module.igw.igw_id
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

module "alb" {
  source       = "../../modules/alb"
  name_prefix  = local.env
  sg_alb_id    = module.sg.sg_alb_id
  subnet_1a_id = module.public_subnet.subnet_alb_1a_id
  subnet_1b_id = module.public_subnet.subnet_alb_1b_id
  vpc_id       = module.vpc.vpc_id
}

module "ecr" {
  source        = "../../modules/ecr"
  name_prefix   = local.name_prefix
  holding_count = 1
}

module "ecs" {
  source                       = "../../modules/ecs"
  name_prefix                  = local.name_prefix
  account_id                   = data.aws_caller_identity.current.account_id
  backend_ecr_repository_url   = module.ecr.backend_ecr_repository_url
  ecs_code_deploy_iam_role_arn = module.iam_role.ecs_code_deploy_iam_role_arn
  ecs_task_iam_role_arn        = module.iam_role.ecs_task_iam_role_arn
  alb_tg_blue_arn              = module.alb.alb_tg_blue_arn
  alb_tg_green_arn             = module.alb.alb_tg_green_arn
  sg_container_id              = module.sg.sg_container_id
  subnet_container_1a_id       = module.private_subnet.subnet_container_1a_id
  subnet_container_1b_id       = module.private_subnet.subnet_container_1b_id
}

module "codedeploy" {
  source                               = "../../modules/codedeploy"
  name_prefix                          = local.name_prefix
  backend_ecs_code_deploy_iam_role_arn = module.iam_role.ecs_code_deploy_iam_role_arn
  backend_ecs_cluster_name             = module.ecs.ecs_cluster_backend_name
  backend_ecs_service                  = module.ecs.ecs_service_backend_name
  backend_alb_tg_blue_name             = module.alb.alb_tg_blue_name
  backend_alb_tg_green_name            = module.alb.alb_tg_green_name
  backend_alb_listener_blue_arn        = module.alb.alb_listener_blue_arn
  backend_alb_listener_green_arn       = module.alb.alb_listener_green_arn
}

