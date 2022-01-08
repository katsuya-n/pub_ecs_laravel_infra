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
  source   = "../../modules/network/vpc"
  name_prefix     = local.name_prefix
  vpc_cidr = local.vpc_cidr
}