output "ecs_cluster_backend_name" {
  value = aws_ecs_cluster.backend.name
}

output "ecs_service_backend_name" {
  value = aws_ecs_service.backend.name
}