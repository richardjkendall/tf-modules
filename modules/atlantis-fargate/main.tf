provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "http" "gh_meta_data" {
  url = "https://api.github.com/meta"
}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "root_zone" {
  name         = "${var.root_domain}."
  private_zone = false
}

data "aws_iam_policy_document" "ecs_service_role_assume_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "service_role_policy" {
  statement {
    sid = "1"
    effect = "Allow"

    actions = ["ssm:GetParameters"]

    resources = [
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter${var.gh_token_secret_name}",
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter${var.gh_webhook_secret_name}"
    ]
  }

  statement {
    sid = "2"
    effect = "Allow"

    actions = [
      "iam:GetRole",
      "iam:PassRole"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/atlantis_terragrunt_deployment_role"
    ]
  }
}

resource "aws_iam_policy" "service_role_policy" {
  policy = data.aws_iam_policy_document.service_role_policy.json
}

resource "aws_iam_role" "service_role" {
  assume_role_policy = data.aws_iam_policy_document.ecs_service_role_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "service_managed_ecs_policy_attach" {
  role       = aws_iam_role.service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "service_role_policy_attach" {
  role       = aws_iam_role.service_role.name
  policy_arn = aws_iam_policy.service_role_policy.arn
}

data "aws_iam_policy_document" "deployment_role_assume_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = [aws_iam_role.service_role.arn]
      type        = "AWS"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "deployment_role" {
  name               = "atlantis_terragrunt_deployment_role"
  assume_role_policy = data.aws_iam_policy_document.deployment_role_assume_policy.json
}

data "aws_iam_policy_document" "deployment_role" {
    statement {
        sid = "1"

        actions = [
            "route53:*",
            "ec2:*",
            "lambda:*",
            "logs:*",
            "cloudfront:*",
            "elasticloadbalancing:*",
            "s3:*",
            "dynamodb:*",
            "ecs:*",
            "apigateway:*",
            "servicediscovery:*"
        ]

        resources = ["*"]
    }

    statement {
        sid = "2"

        actions = [
            "ssm:GetParameters",
            "ssm:GetParameter"
        ]

        resources = ["*"]
    }

    statement {
        sid = "3"

        actions = [
            "secretsmanager:Describe*",
            "secretsmanager:Get*"
        ]

        resources = ["*"]
    }

    statement {
        sid = "4"

        actions = [
            "iam:AttachGroupPolicy",
            "iam:AttachRolePolicy",
            "iam:CreateGroup",
            "iam:CreatePolicy",
            "iam:CreatePolicyVersion",
            "iam:CreateRole",
            "iam:DeleteGroup",
            "iam:DeleteGroupPolicy",
            "iam:DeletePolicy",
            "iam:DeleteRole",
            "iam:DeleteRolePolicy",
            "iam:DetachGroupPolicy",
            "iam:DetachRolePolicy",
            "iam:GetGroupPolicy",
            "iam:GetPolicy",
            "iam:GetPolicyVersion",
            "iam:GetRole",
            "iam:GetRolePolicy",
            "iam:ListAttachedGroupPolicies",
            "iam:ListAttachedRolePolicies",
            "iam:ListGroupPolicies",
            "iam:ListGroups",
            "iam:ListPolicies",
            "iam:ListPolicyVersions",
            "iam:ListRolePolicies",
            "iam:ListRoles",
            "iam:UpdateGroup",
            "iam:UpdateRole",
            "iam:CreateInstanceProfile"
        ]

        resources = ["*"]
    }

    statement {
        sid = "5"

        actions = [
            "acm:DescribeCertificate",
            "acm:GetCertificate",
            "acm:ListCertificates",
            "acm:RequestCerfificate"
        ]

        resources = ["*"]
    }
}

resource "aws_iam_policy" "deployment_role_policy" {
  policy = data.aws_iam_policy_document.deployment_role.json
}

resource "aws_iam_role_policy_attachment" "deployment_role_policy_attach" {
  role       = aws_iam_role.deployment_role.name
  policy_arn = aws_iam_policy.deployment_role_policy.arn
}

resource "aws_iam_role_policy_attachment" "user_deployment_policies" {
  count       = length(var.deployment_role_policies)

  role        = aws_iam_role.deployment_role.name
  policy_arn  = element(var.deployment_role_policies, count.index)
}

resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "/ecs/atlantis"
}

resource "random_string" "random_secret" {
  length = 20
  special = true
}

resource "aws_ecs_task_definition" "task" {
  depends_on    = [aws_cloudwatch_log_group.logs]
  family        = var.task_def_name

  container_definitions = templatefile("${path.module}/atlantis.json", {
    gh_user           = var.gh_user
    whitelist         = var.gh_repo_whitelist
    url               = "https://${var.host_name}.${var.root_domain}"
    iam_role          = aws_iam_role.deployment_role.arn
    repoconfig        = "${jsonencode(file("${path.module}/repoconfig.json"))}"
    gh_webhook_secret = var.gh_webhook_secret_name
    gh_token          = var.gh_token_secret_name
    region            = var.aws_region
    log_group         = "/etc/atlantis"
    random_secret     = random_string.random_secret.result
    cpu               = var.cpu
    memory            = var.memory
  })

  execution_role_arn        = aws_iam_role.service_role.arn
  task_role_arn             = aws_iam_role.service_role.arn
  requires_compatibilities  = ["FARGATE"]
  network_mode              = "awsvpc"
  cpu                       = var.cpu
  memory                    = var.memory
}

resource "aws_ecs_service" "service" {
  name              = "atlantis"
  cluster           = aws_ecs_cluster.cluster.id
  task_definition   = aws_ecs_task_definition.task.arn
  desired_count     = 1
  launch_type       = "FARGATE"

  load_balancer {
    container_name    = "atlantis"
    container_port    = "4141"
    target_group_arn  = aws_lb_target_group.target_group.arn
  }

  network_configuration {
    subnets           = var.task_subnets
    security_groups   = [aws_security_group.task_p_4141.id]
  }
}

resource "aws_security_group" "task_p_4141" {
  name        = "allow_port_4141_for_task"
  description = "Allow Atlantis port 4141 from LB"

  dynamic "ingress" {
    for_each = var.create_lb == true ? ["b"] : []

    content {
      from_port       = 4141
      to_port         = 4141
      protocol        = "tcp"
      security_groups = [aws_security_group.allow_tls.0.id]
    }
  }

  dynamic "ingress" {
    for_each = var.create_lb == true ? [] : ["b"]

    content {
      from_port       = 4141
      to_port         = 4141
      protocol        = "tcp"
      security_groups = [var.lb_sec_group_id]
    }
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_tls" {
  count = var.create_lb == true ? 1 : 0

  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = lookup(jsondecode(data.http.gh_meta_data.body), "hooks", var.allowed_ips)
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "lb" {
  count = var.create_lb == true ? 1 : 0

  internal            = false
  load_balancer_type  = "application"
  security_groups     = [aws_security_group.allow_tls.0.id]
  subnets             = var.lb_subnets
}

resource "aws_lb_target_group" "target_group" {
  port                  = "4141"
  protocol              = "HTTP"
  vpc_id                = var.vpc_id
  target_type           = "ip"
  deregistration_delay  = 10
}

resource "aws_lb_listener" "alb_listener" {
  count = var.create_lb == true ? 1 : 0

  load_balancer_arn = aws_lb.lb.0.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.listener_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_listener_certificate" "lb_cert_attach" {
  count = var.create_lb == true ? 0 : 1

  listener_arn    = var.listener_arn
  certificate_arn = aws_acm_certificate.listener_cert.arn
}

resource "aws_lb_listener_rule" "lb_listener_rule" {
  count = var.create_lb == true ? 0 : 1

  listener_arn = var.listener_arn
  priority     = var.rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    host_header {
      values = ["${var.host_name}.${var.root_domain}"]
    }
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

resource "aws_route53_record" "r53_alb" {
  count = var.create_lb == true ? 1 : 0

  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = "${var.host_name}.${var.root_domain}"
  type    = "A"

  alias {
    name                   = aws_lb.lb.0.dns_name
    zone_id                = aws_lb.lb.0.zone_id
    evaluate_target_health = true
  }
}

data "aws_lb" "existing_lb" {
  count = var.create_lb == true ? 0 : 1

  arn = var.lb_arn
}

resource "aws_route53_record" "r53_existing_alb" {
  count = var.create_lb == true ? 0 : 1

  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = "${var.host_name}.${var.root_domain}"
  type    = "A"

  alias {
    name                   = data.aws_lb.existing_lb.0.dns_name
    zone_id                = data.aws_lb.existing_lb.0.zone_id
    evaluate_target_health = true
  }
}