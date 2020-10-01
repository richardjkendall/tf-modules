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
  aliases   = [join(".", [var.sitename_prefix, var.domain_root])]
  origin_id = join("-", ["access-identity", var.sitename_prefix, var.domain_root])
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
  bucket = "${var.sitename_prefix}.${var.domain_root}"

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
    domain_name = aws_s3_bucket.cf_origin_s3_bucket.bucket_domain_name
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
    acm_certificate_arn      = aws_acm_certificate.endpoint_cert.arn
    ssl_support_method       = "sni-only"
  }

  depends_on = [aws_acm_certificate_validation.cert_validation]
}

resource "aws_acm_certificate" "endpoint_cert" {
  provider          = aws.us-east-1
  domain_name       = "${var.sitename_prefix}.${var.domain_root}"
  validation_method = "DNS"
}

resource "aws_route53_record" "endpoint_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.endpoint_cert.domain_validation_options : dvo.domain_name => {
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
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.endpoint_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.endpoint_cert_validation : record.fqdn]
}

resource "aws_route53_record" "cf_endpoint_domain_r53" {
  name    = "${var.sitename_prefix}.${var.domain_root}"
  type    = "A"
  zone_id = data.aws_route53_zone.root_zone.id

  alias {
    evaluate_target_health = true
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
  }
}