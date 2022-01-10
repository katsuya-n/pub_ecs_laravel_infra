locals {
  name_prefix                    = "ecs_laravel_pj_dev"
  env                            = "dev"
  vpc_cidr                       = "10.0.0.0/16"
  alb_subnet_cidr_block_1a       = "10.0.2.0/24"
  alb_subnet_cidr_block_1b       = "10.0.3.0/24"
  container_subnet_cidr_block_1a = "10.0.4.0/24"
  container_subnet_cidr_block_1b = "10.0.5.0/24"
  rds_subnet_cidr_block_1a       = "10.0.8.0/24"
  rds_subnet_cidr_block_1b       = "10.0.9.0/24"
  az_1a                          = "us-east-1a"
  az_1b                          = "us-east-1b"
}