output "subnet_container_1a_id" {
  value = aws_subnet.private_container_1a.id
}

output "subnet_container_1b_id" {
  value = aws_subnet.private_container_1b.id
}

output "subnet_db_1a_id" {
  value = aws_subnet.private_rds_1a.id
}

output "subnet_db_1b_id" {
  value = aws_subnet.private_rds_1b.id
}