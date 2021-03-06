/*
title: static-site-azure-cicd
desc: Deploys a simple static site on CloudFront backed by an S3 origin with CICD from an azure devops repo.  Works with the azure-clone-to-s3 API.
partners: static-site-azure-cicd-oidc-auth, azure-clone-to-s3
depends: static-site, basic-cicd-s3-to-s3-pipeline
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

module "static_site" {
  source              = "../static-site/"
  sitename_prefix     = var.sitename_prefix
  domain_root         = var.domain_root
  aws_region          = var.aws_region
  access_log_bucket   = var.access_log_bucket
  access_log_prefix   = var.access_log_prefix
  encrypt_buckets     = var.encrypt_buckets

  viewer_req_edge_lambda_arns = var.viewer_req_edge_lambda_arns

  fix_non_specific_paths = var.fix_non_specific_paths
  custom_404_path        = var.custom_404_path

  certificate_arn       = var.certificate_arn
  alternative_dns_names = var.alternative_dns_names

  origin_access_log_bucket = var.origin_access_log_bucket
  origin_access_log_prefix = var.origin_access_log_prefix
}

module "cicd" {
  source                    = "../basic-cicd-s3-to-s3-pipeline/"
  aws_region                = var.aws_region
  site_name                 = "${var.sitename_prefix}.${var.domain_root}"
  cf_distribution           = module.static_site.cf_distribution_id
  s3_bucket                 = module.static_site.cf_origin_s3_bucket_id
  encrypt_buckets           = var.encrypt_buckets
  allow_root                = var.allow_root
  build_image               = var.build_image
  build_compute_type        = var.build_compute_type

  source_s3_bucket = var.source_s3_bucket
  source_s3_prefix = var.source_s3_prefix

  access_log_bucket = var.pipeline_access_log_bucket
  access_log_prefix = var.pipeline_access_log_prefix

  build_role_policies = var.build_role_policies
  build_environment   = var.build_environment
}