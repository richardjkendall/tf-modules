/*
title: static-site-cicd-oidc-auth
desc: Deploys a simple static site on CloudFront backed by an S3 origin with CICD from github and protected by OIDC based login.
depends: static-site-with-cicd, lambda-function
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

locals {
  domain_root_wo_dots = replace(var.domain_root, ".", "-")
  sitename_prefix_wo_dots = replace(var.sitename_prefix, ".", "-")
}

module "static_site" {
  source = "../static-site-with-cicd/"

  /* static site */
  sitename_prefix     = var.sitename_prefix
  domain_root         = var.domain_root
  aws_region          = var.aws_region
  access_log_bucket   = var.access_log_bucket
  access_log_prefix   = var.access_log_prefix

  /* cicd */
  gh_username               = var.gh_username
  gh_secret_sm_param_name   = var.gh_secret_sm_param_name
  gh_token_sm_param_name    = var.gh_token_sm_param_name
  gh_repo                   = var.gh_repo
  gh_branch                 = var.gh_branch
  encrypt_buckets           = var.encrypt_buckets
  allow_root                = var.allow_root

  /* notifications */
  send_notifications          = var.send_notifications
  sns_topic_for_notifications = var.sns_topic_for_notifications
  notifications_to_send       = var.notifications_to_send

  /* auth related */
  viewer_req_edge_lambda_arns = [
    module.lambda.qualified_arn
  ]
}

module "lambda" {
  source = "../lambda-function"

  /* need to provision in us-east-1 for lambda@edge to work */
  aws_region        = "us-east-1"

  function_name     = "jwtauth-${local.sitename_prefix_wo_dots}-${local.domain_root_wo_dots}-${var.gh_branch}"
  function_handler  = "lambda.lambda_handler"
  runtime           = "python3.7"
  memory            = 128
  timeout           = 5

  environment_variables = {}

  code_repository         = "https://github.com/richardjkendall/cf-edge-jwt.git"
  execution_role_policies = []
  publish                 = true

  build_environment = {
    HOST            = var.keycloak_host
    REALM           = var.realm 
    CLIENT_ID       = var.client_id
    CLIENT_SECRET   = var.client_secret 
    AUTH_COOKIE     = var.auth_cookie_name
    REFRESH_COOKIE  = var.refresh_cookie_name
    REDIRECT_URI    = "https://${var.sitename_prefix}.${var.domain_root}/_login"
    VAL_API_URL     = var.val_api_url
  }
}