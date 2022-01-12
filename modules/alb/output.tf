output "alb_tg_blue_arn" {
  value = aws_lb_target_group.blue.arn
}

output "alb_tg_blue_name" {
  value = aws_lb_target_group.blue.name
}

output "alb_listener_blue_arn" {
  value = aws_lb_listener.blue.arn
}

output "alb_tg_green_arn" {
  value = aws_lb_target_group.green.arn
}

output "alb_tg_green_name" {
  value = aws_lb_target_group.green.name
}

output "alb_listener_green_arn" {
  value = aws_lb_listener.green.arn
}