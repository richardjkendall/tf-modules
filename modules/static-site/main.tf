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

  cors_rule {
    allowed_methods = ["HEAD", "GET", "PUT", "POST"]
    allowed_origins = ["https*"]
    allowed_headers = ["*"]
    expose_headers  = ["ETag", "x-amz-meta-custom-header"]
  }
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
}

resource "aws_acm_certificate" "endpoint_cert" {
  provider          = "aws.us-east-1"
  domain_name       = "${var.sitename_prefix}.${var.domain_root}"
  validation_method = "DNS"
}

resource "aws_route53_record" "endpoint_cert_validation" {
  name    = "${aws_acm_certificate.endpoint_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.endpoint_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.root_zone.id}"
  records = ["${aws_acm_certificate.endpoint_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  provider                = "aws.us-east-1"
  certificate_arn         = "${aws_acm_certificate.endpoint_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.endpoint_cert_validation.fqdn}"]
}

resource "aws_route53_record" "cf_endpoint_domain_r53" {
  name    = "${var.sitename_prefix}.${var.domain_root}"
  type    = "A"
  zone_id = "${data.aws_route53_zone.root_zone.id}"

  alias {
    evaluate_target_health = true
    name                   = "${aws_cloudfront_distribution.cdn.cloudfront_domain_name}"
    zone_id                = "${aws_cloudfront_distribution.cdn.cloudfront_zone_id}"
  }
}