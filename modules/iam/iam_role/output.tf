output "ecs_code_deploy_iam_role_arn" {
  value = aws_iam_role.ecs_code_deploy.arn
}

output "ecs_task_iam_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}