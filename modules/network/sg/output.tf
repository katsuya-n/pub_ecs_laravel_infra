output "sg_vpce_id" {
  value = aws_security_group.vpce.id
}

output "sg_alb_id" {
  value = aws_security_group.alb.id
}