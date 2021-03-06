variable "name_prefix" {}
variable "account_id" {}
variable "backend_ecr_repository_url" {}
variable "ecs_code_deploy_iam_role_arn" {}
variable "ecs_task_iam_role_arn" {}
variable "alb_tg_blue_arn" {}
variable "alb_tg_green_arn" {}
variable "sg_container_id" {}
variable "subnet_container_1a_id" {}
variable "subnet_container_1b_id" {}
variable "backend_desired_count" {}