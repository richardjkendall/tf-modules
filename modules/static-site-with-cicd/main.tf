/*
title: static-site-with-cicd
desc: Deploys a simple static site on CloudFront backed by an S3 origin with CICD from github.
partners: static-site-cicd-oidc-auth
depends: static-site, basic-cicd-s3-pipeline
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
  deploy_at_apex      = var.deploy_at_apex
  domain_root         = var.domain_root
  aws_region          = var.aws_region
  access_log_bucket   = var.access_log_bucket
  access_log_prefix   = var.access_log_prefix
  encrypt_buckets     = var.encrypt_buckets

  viewer_req_edge_lambda_arns = var.viewer_req_edge_lambda_arns

  fix_non_specific_paths = var.fix_non_specific_paths
  custom_404_path        = var.custom_404_path

  origin_access_log_bucket = var.origin_access_log_bucket
  origin_access_log_prefix = var.origin_access_log_prefix

  certificate_arn       = var.certificate_arn
  alternative_dns_names = var.alternative_dns_names
}

module "cicd" {
  source                    = "../basic-cicd-s3-pipeline/"
  aws_region                = var.aws_region
  gh_username               = var.gh_username
  gh_secret_sm_param_name   = var.gh_secret_sm_param_name
  gh_token_sm_param_name    = var.gh_token_sm_param_name
  gh_repo                   = var.gh_repo
  gh_branch                 = var.gh_branch
  site_name                 = "${var.sitename_prefix}.${var.domain_root}"
  cf_distribution           = module.static_site.cf_distribution_id
  s3_bucket                 = module.static_site.cf_origin_s3_bucket_id
  encrypt_buckets           = var.encrypt_buckets
  allow_root                = var.allow_root
  build_image               = var.build_image

  send_notifications          = var.send_notifications
  sns_topic_for_notifications = var.sns_topic_for_notifications
  notifications_to_send       = var.notifications_to_send

  access_log_bucket = var.pipeline_access_log_bucket
  access_log_prefix = var.pipeline_access_log_prefix

  build_role_policies = var.build_role_policies
  build_environment   = var.build_environment
  build_compute_type  = var.build_compute_type
}