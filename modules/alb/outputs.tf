output "lb_arn" {
  value = aws_lb.lb.arn
}

output "listener_arn" {
  value = aws_lb_listener.alb_listener.arn
}