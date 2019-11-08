provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
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
      identifiers = ["codebuild.amazonaws.com"]
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
  policy = "${data.aws_iam_policy_document.code_pipeline_policy_document.json}"
}

resource "aws_iam_role" "service_role" {
  assume_role_policy = "${data.aws_iam_policy_document.ecs_service_role_assume_policy.json}"
}

resource "aws_iam_role_policy_attachment" "service_managed_ecs_policy_attach" {
  role       = "${aws_iam_role.service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "service_role_policy_attach" {
  role       = "${aws_iam_role.service_role.name}"
  policy_arn = "${aws_iam_policy.service_role_policy.arn}"
}

data "aws_iam_policy_document" "deployment_role_assume_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["${aws_iam_role.service_role.arn}"]
      type        = "AWS"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "deployment_role" {
  name               = "atlantis_terragrunt_deployment_role"
  assume_role_policy = "${data.aws_iam_policy_document.deployment_role_assume_policy.json}"
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
            "apigateway:*"
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
            "iam:DeleteGroup",
            "iam:UpdateGroup",
            "iam:DeletePolicy",
            "iam:CreateRole",
            "iam:AttachRolePolicy",
            "iam:DetachRolePolicy",
            "iam:DeleteRolePolicy",
            "iam:ListAttachedRolePolicies",
            "iam:DetachGroupPolicy",
            "iam:ListAttachedGroupPolicies",
            "iam:ListRolePolicies",
            "iam:ListPolicies",
            "iam:GetRole",
            "iam:CreateGroup",
            "iam:GetPolicy",
            "iam:ListGroupPolicies",
            "iam:ListRoles",
            "iam:DeleteRole",
            "iam:CreatePolicy",
            "iam:AttachGroupPolicy",
            "iam:UpdateRole",
            "iam:ListGroups",
            "iam:GetGroupPolicy",
            "iam:DeleteGroupPolicy",
            "iam:GetRolePolicy"
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
  policy = "${data.aws_iam_policy_document.deployment.json}"
}

resource "aws_iam_role_policy_attachment" "deployment_role_policy_attach" {
  role       = "${aws_iam_role.deployment_role.name}"
  policy_arn = "${aws_iam_policy.deployment_role_policy.arn}"
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.ecs_cluster_name}"
}

resource "aws_ecs_task_definition" "task" {
  family                = "${var.task_def_name}"

  container_definitions = "${templatefile("atlantis.json", {
    gh_user           = "${var.gh_user}"
    whitelist         = "${var.gh_repo_whitelist}"
    url               = "https://${var.host_name}.${var.root_domain}"
    iam_role          = "${aws_iam_role.deployment_role.arn}"
    repoconfig        = "${jsonencode(file("repoconfig.json"))}"
    gh_webook_secret  = "${var.gh_webhook_secret_name}"
    gh_token          = "${var.gh_token_secret_name}"
  })}"

  execution_role_arn  = "${aws_iam_role.service_role.arn}"
}

resource "aws_ecs_service" "service" {
  name              = "atlantis"
  cluster           = "${aws_ecs_cluster.cluster.id}"
  task_definition   = "${aws_ecs_task_definition.task.arn}"
  desired_count     = 1
  launch_type       = "FARGATE"

  load_balancer {
    container_name    = "atlantis"
    container_port    = "4141"
    target_group_arn  = "${aws_lb_target_group.target_group.arn}"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }
}

resource "aws_lb" "lb" {
  internal            = false
  load_balancer_type  = "application"
  security_groups     = ["${aws_security_group.allow_tls.id}"]
  subnets             = var.subnets
}

resource "aws_lb_target_group" "target_group" {}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = "${aws_lb.aws_lb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${aws_acm_certificate.listener_cert.arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group.arn}"
  }
}

resource "aws_acm_certificate" "listener_cert" {
  domain_name       = "${var.host_name}.${var.root_domain}"
  validation_method = "DNS"
}

resource "aws_route53_record" "listener_cert_validation" {
  name    = "${aws_acm_certificate.listener_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.listener_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.root_zone.id}"
  records = ["${aws_acm_certificate.listener_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = "${aws_acm_certificate.listener_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.listener_cert_validation.fqdn}"]
}

resource "aws_route53_record" "r53_alb" {
  zone_id = "${aws_route53_zone.root_zone.zone_id}"
  name    = "${var.host_name}.${var.root_domain}"
  type    = "A"

  alias {
    name                   = "${aws_lb.lb.dns_name}"
    zone_id                = "${aws_lb.lb.zone_id}"
    evaluate_target_health = true
  }
}