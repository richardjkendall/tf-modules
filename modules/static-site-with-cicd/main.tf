provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

module "static_site" {
  source              = "../static-site/"
  sitename_prefix     = "${var.sitename_prefix}"
  domain_root         = "${var.domain_root}"
  aws_region          = "${var.aws_region}"
  access_log_bucket   = "${var.access_log_bucket}"
  access_log_prefix   = "${var.access_log_prefix}"

  viewer_req_edge_lambda_arns = var.viewer_req_edge_lambda_arns
}

module "cicd" {
  source                    = "../basic-cicd-s3-pipeline/"
  aws_region                = "${var.aws_region}"
  gh_username               = "${var.gh_username}"
  gh_secret_sm_param_name   = "${var.gh_secret_sm_param_name}"
  gh_token_sm_param_name    = "${var.gh_token_sm_param_name}"
  gh_repo                   = "${var.gh_repo}"
  gh_branch                 = "${var.gh_branch}"
  site_name                 = "${var.sitename_prefix}.${var.domain_root}"
  cf_distribution           = "${module.static_site.cf_distribution_id}"
  s3_bucket                 = "${module.static_site.cf_origin_s3_bucket_id}"
}