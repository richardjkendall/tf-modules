/*
title: lambda-function-with-layer
desc: Deploys a python lambda function with a layer beneath to manage dependencies
depends: lambda-function, lambda-layer
*/


terraform {
  backend "s3" {}
}

module "lambda" {
  source = "../lambda-function"

  aws_region        = var.aws_region
  function_name     = var.function_name
  function_handler  = var.function_handler
  memory            = var.memory
  timeout           = var.timeout
  lambda_layers     = [ module.layer.layer_arn ]
  runtime           = var.runtime

  environment_variables = var.function_environment
  build_environment     = var.function_build_environment

  code_repository         = var.function_code_repository
  execution_role_policies = var.execution_role_policies
}

module "layer" {
  source = "../lambda-layer"
  
  layer_name        = "${var.function_name}-layer"
  runtime           = var.runtime
  code_repository   = var.layer_code_repository
  build_environment = var.layer_build_environment
  layer_bucket      = var.layer_bucket
}