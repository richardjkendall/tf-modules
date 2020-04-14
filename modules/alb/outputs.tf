output "lb_arn" {
  value = aws_lb.lb.arn
}

output "listener_arn" {
  value = aws_lb_listener.alb_listener.arn
}

output "lb_sec_group_id" {
  value = aws_security_group.allow_tls.id
}