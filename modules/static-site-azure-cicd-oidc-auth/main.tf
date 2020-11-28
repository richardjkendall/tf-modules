/*
title: static-site-azure-cicd-oidc-auth
desc: Deploys a simple static site on CloudFront backed by an S3 origin with CICD from azure devops and protected by OIDC based login.
partners: azure-clone-to-s3
depends: static-site-azure-cicd, lambda-function
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
  source              = "../static-site-azure-cicd/"

  /* static site */
  sitename_prefix        = var.sitename_prefix
  domain_root            = var.domain_root
  aws_region             = var.aws_region
  access_log_bucket      = var.access_log_bucket
  access_log_prefix      = var.access_log_prefix
  encrypt_buckets        = var.encrypt_buckets
  fix_non_specific_paths = var.fix_non_specific_paths
  custom_404_path        = var.custom_404_path
  certificate_arn        = var.certificate_arn
  alternative_dns_names  = var.alternative_dns_names

  origin_access_log_bucket = var.origin_access_log_bucket
  origin_access_log_prefix = var.origin_access_log_prefix

  /* cicd */
  allow_root          = var.allow_root
  build_image         = var.build_image
  source_s3_bucket    = var.source_s3_bucket
  source_s3_prefix    = var.source_s3_prefix

  pipeline_access_log_bucket = var.pipeline_access_log_bucket
  pipeline_access_log_prefix = var.pipeline_access_log_prefix

  /* auth related */
  viewer_req_edge_lambda_arns = [
    module.lambda.qualified_arn
  ]
}

module "lambda" {
  source = "../lambda-function"

  /* need to provision in us-east-1 for lambda@edge to work */
  aws_region        = "us-east-1"

  function_name     = "jwtauth-${local.sitename_prefix_wo_dots}-${local.domain_root_wo_dots}-${var.source_s3_prefix}"
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
    REDIRECT_URI    = var.oidc_redirect_url != "" ? var.oidc_redirect_url : "https://${var.sitename_prefix}.${var.domain_root}/_login"
    VAL_API_URL     = var.val_api_url
  }
}