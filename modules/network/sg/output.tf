output "sg_vpce_id" {
  value = aws_security_group.vpce.id
}

output "sg_alb_id" {
  value = aws_security_group.alb.id
}

output "sg_container_id" {
  value = aws_security_group.container.id
}

output "sg_rds_id" {
  value = aws_security_group.rds.id
}