provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

locals {
  site_name = var.sitename_prefix == "" ? "${var.domain_root}" : "${var.sitename_prefix}.${var.domain_root}"
}

data "aws_route53_zone" "root_zone" {
  name         = "${var.domain_root}."
  private_zone = false
}

resource "aws_s3_bucket" "redirect_s3_bucket" {
  bucket  = "${local.site_name}"
  acl     = "private"

  website {
    redirect_all_requests_to = "${var.redirect_protocol}://${var.redirect_target_domain}"
  }
}

resource "aws_s3_bucket_public_access_block" "block_redirect_s3_bucket_pub_access" {
  bucket = "${aws_s3_bucket.redirect_s3_bucket.id}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_route53_record" "redirect_domain" {
  name    = "${local.site_name}"
  type    = "A"
  zone_id = "${data.aws_route53_zone.root_zone.id}"

  alias {
    evaluate_target_health = true
    name                   = "${aws_s3_bucket.redirect_s3_bucket.website_domain}"
    zone_id                = "${aws_s3_bucket.redirect_s3_bucket.hosted_zone_id}"
  }
}