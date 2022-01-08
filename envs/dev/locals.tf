locals {
  name_prefix              = "ecs_laravel_pj_dev"
  vpc_cidr                 = "10.0.0.0/16"
  alb_subnet_cidr_block_1a = "10.0.2.0/24"
  alb_subnet_cidr_block_1b = "10.0.3.0/24"
  alb_subnet_subnet_az_1a  = "us-east-1a"
  alb_subnet_subnet_az_1b  = "us-east-1b"
}