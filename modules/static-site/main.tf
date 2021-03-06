/*
title: static-site
desc: Deploys a simple static site on CloudFront backed by an S3 origin.  Logs access request to S3.
partners: static-site-with-cicd, static-site-cicd-oidc-auth
*/

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

terraform {
  backend "s3" {}
}

locals {
  full_site_name          = var.deploy_at_apex ? var.domain_root : join(".", [var.sitename_prefix, var.domain_root])
  aliases                 = concat([local.full_site_name], var.alternative_dns_names)
  origin_id               = join("-", ["access-identity", var.sitename_prefix, var.domain_root])
  domain_root_wo_dots     = replace(var.domain_root, ".", "-")
  sitename_prefix_wo_dots = replace(var.sitename_prefix, ".", "-")


  custom_error_response = var.custom_404_path == "none" ? [] : [
    {
      error_code         = 404
      response_code      = 404
      response_page_path = var.custom_404_path
    }
  ]
}

resource "aws_cloudfront_origin_access_identity" "static_website_origin_access_identity" {
  comment = local.origin_id
}

data "aws_s3_bucket" "access_log" {
  bucket = var.access_log_bucket
}

data "aws_route53_zone" "root_zone" {
  name         = "${var.domain_root}."
  private_zone = false
}

resource "aws_s3_bucket" "cf_origin_s3_bucket" {
  bucket = local.full_site_name

  acl = "private"

  force_destroy = true

  cors_rule {
    allowed_methods = ["HEAD", "GET", "PUT", "POST"]
    allowed_origins = ["https*"]
    allowed_headers = ["*"]
    expose_headers  = ["ETag", "x-amz-meta-custom-header"]
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.encrypt_buckets == true ? [ "blah" ] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
      }
    }
  }

  dynamic "logging" {
    for_each = var.origin_access_log_bucket != "" ? [ "blah" ] : []

    content {
      target_bucket = var.origin_access_log_bucket
      target_prefix = var.origin_access_log_prefix
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block_cf_origin_bucket_pub_access" {
  bucket = aws_s3_bucket.cf_origin_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    effect    = "Allow"
    resources = ["arn:aws:s3:::${aws_s3_bucket.cf_origin_s3_bucket.bucket}/*"]
    actions   = ["s3:GetObject"]
    principals {
      identifiers = [aws_cloudfront_origin_access_identity.static_website_origin_access_identity.iam_arn]
      type        = "AWS"
    }
  }

  statement {
    effect    = "Allow"
    resources = ["arn:aws:s3:::${aws_s3_bucket.cf_origin_s3_bucket.bucket}"]
    actions   = ["s3:ListBucket"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.static_website_origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cf_origin_bucket_policy" {
  bucket = aws_s3_bucket.cf_origin_s3_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

module "lambda" {
  count = var.fix_non_specific_paths ? 1 : 0

  source = "../lambda-function-node"

  providers = {
    aws = aws.us-east-1
  }

  /* need to provision in us-east-1 for lambda@edge to work */
  aws_region        = "us-east-1"

  function_name     = "fix-roots-${local.sitename_prefix_wo_dots}-${local.domain_root_wo_dots}"
  function_handler  = "index.handler"
  memory            = 128
  timeout           = 5

  environment_variables = {}

  code_repository         = "https://github.com/richardjkendall/fix-cf-root.git"
  execution_role_policies = []
  publish                 = true
}

resource "aws_cloudfront_distribution" "cdn" {
  aliases             = local.aliases
  is_ipv6_enabled     = true
  http_version        = var.http_version
  default_root_object = var.root_object_location
  price_class         = var.price_class

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id
    forwarded_values {
      cookies {
        forward = "none"
      }
      headers      = ["Origin"]
      query_string = false
    }

    dynamic "lambda_function_association" {
      for_each = var.viewer_req_edge_lambda_arns

      content {
        event_type   = "viewer-request"
        lambda_arn   = lambda_function_association.value
        include_body = false
      }
    }

    dynamic "lambda_function_association" {
      for_each = var.fix_non_specific_paths ? [1] : []

      content {
        event_type   = "origin-request"
        lambda_arn   = module.lambda.0.qualified_arn
        include_body = false
      }
    }

    max_ttl                = var.max_ttl
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    viewer_protocol_policy = "redirect-to-https"
  }

  logging_config {
    bucket          = data.aws_s3_bucket.access_log.bucket_domain_name
    prefix          = var.access_log_prefix
    include_cookies = false
  }

  enabled = true

  origin {
    origin_id   = local.origin_id
    domain_name = aws_s3_bucket.cf_origin_s3_bucket.bucket_regional_domain_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.static_website_origin_access_identity.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    minimum_protocol_version = "TLSv1.2_2018"
    acm_certificate_arn      = var.certificate_arn != "" ? var.certificate_arn : aws_acm_certificate.endpoint_cert.0.arn
    ssl_support_method       = "sni-only"
  }

  dynamic "custom_error_response" {
    for_each = var.custom_404_path == "none" ? [] : [ "blah" ]

    content {
      error_code         = 404
      response_code      = 404
      response_page_path = var.custom_404_path
    }
  }

  tags = {
    CertDependTag = var.certificate_arn != "" ? var.certificate_arn : aws_acm_certificate_validation.cert_validation.0.id
  }

}

resource "aws_acm_certificate" "endpoint_cert" {
  count = var.certificate_arn != "" ? 0 : 1

  provider          = aws.us-east-1
  domain_name       = local.full_site_name
  validation_method = "DNS"
}

resource "aws_route53_record" "endpoint_cert_validation" {
  for_each = var.certificate_arn != "" ? {} : {
    for dvo in aws_acm_certificate.endpoint_cert.0.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.root_zone.id
}

resource "aws_acm_certificate_validation" "cert_validation" {
  count = var.certificate_arn != "" ? 0 : 1

  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.endpoint_cert.0.arn
  validation_record_fqdns = [for record in aws_route53_record.endpoint_cert_validation : record.fqdn]
}

resource "aws_route53_record" "cf_endpoint_domain_r53" {
  name    = local.full_site_name
  type    = "A"
  zone_id = data.aws_route53_zone.root_zone.id

  alias {
    evaluate_target_health = true
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
  }
}