/*
title: alb
desc: Creates an ALB with a linked HTTPS listener.  Designed to be used with other modules which add target groups and listener rules.
partners: ecs-haproxy, atlantis-fargate
*/

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

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.listener_cert.arn

  default_action {
    type             = "redirect"
    redirect {
      status_code    = "HTTP_302"
      protocol       = var.def_redir_scheme
      host           = var.def_redir_host
      path           = var.def_redir_path
    }
  }
}

resource "aws_route53_record" "r53_alb" {
  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = "${var.host_name}.${var.root_domain}"
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "listener_cert" {
  domain_name       = "${var.host_name}.${var.root_domain}"
  validation_method = "DNS"
}

resource "aws_route53_record" "listener_cert_validation" {
  name    = aws_acm_certificate.listener_cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.listener_cert.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.root_zone.id
  records = [aws_acm_certificate.listener_cert.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.listener_cert.arn
  validation_record_fqdns = [aws_route53_record.listener_cert_validation.fqdn]
}