provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_route53_zone" "root_zone" {
  name         = "${var.root_domain}."
  private_zone = false
}

resource "aws_security_group" "allow_tls_from_world" {
  name_prefix = "allow_tls_for_alb"
  description = "Allow TLS inbound traffic"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "lb" {
  internal            = false
  load_balancer_type  = "application"
  security_groups     = [aws_security_group.allow_tls_from_world.id]
  subnets             = var.lb_subnets
}

resource "aws_lb_target_group" "target_group" {
  port                  = "80"
  protocol              = "HTTP"
  vpc_id                = var.vpc_id
  target_type           = "instance"
  deregistration_delay  = 10
  health_check {
    matcher             = "200,302"
    path                = "/haproxy"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    port                = "traffic-port"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.listener_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_route53_record" "r53_alb" {
  zone_id = "${data.aws_route53_zone.root_zone.zone_id}"
  name    = "${var.host_name}.${var.root_domain}"
  type    = "A"

  alias {
    name                   = "${aws_lb.lb.dns_name}"
    zone_id                = "${aws_lb.lb.zone_id}"
    evaluate_target_health = true
  }
}

module "ecs_haproxy" {
  source = "../ecs-service/"

  aws_region      = var.aws_region
  cluster_name    = var.cluster_name
  service_name    = var.service_name
  task_name       = var.task_name
  image           = "richardjkendall/haproxy:${var.tag_name}"
  cpu             = var.cpu
  memory          = var.memory
  number_of_tasks = var.number_of_tasks

  port_mappings = [{
    containerPort = 80
    protocol = "tcp"
    hostPort = 0
  }]

  healthcheck = {
    command     = [ "CMD-SHELL", "curl --fail http://localhost:3000/ || exit 1" ]
    interval    = 30
    timeout     = 5
    retries     = 3
    startPeriod = 20
  }

  environment = [
    { name = "APPLY_MODE"
      value = "on" },
    { name = "AWS_REGION"
      value = var.aws_region },
    { name = "DEFAULT_DOMAIN"
      value = var.default_domain },
    { name = "NAMESPACE_MAP"
      value = jsonencode(var.namespace_map) },
    { name = "REFRESH_RATE"
      value = var.refresh_rate }
  ]

  secrets = [
    { name = "PROM_PASSWD"
      valueFrom = var.prom_password_ssm_secret },
    { name = "STATS_PASSWD"
      valueFrom = var.stats_password_ssm_secret }
  ]
  
  load_balancer = {
    target_group_arn  = aws_lb_target_group.target_group.arn
    container_name    = var.task_name
    container_port    = 80
  }

  service_registry_id           = var.service_registry_id
  service_registry_service_name = var.service_registry_service_name
}