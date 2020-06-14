/*
title: api-lambda
desc: Exposes a python lambda function as an API using API gateway.  Lambda function code must be in a public github repo.
depends: lambda-function
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

module "lambda_function" {
  source = "../lambda-function"

  aws_region        = var.aws_region
  function_name     = var.function_name
  function_handler  = var.handler
  runtime           = var.runtime
  timeout           = var.timeout
  memory            = var.memory
  code_repository   = var.code_repository
  
  execution_role_policies = var.execution_role_policies

  environment_variables = var.environment_variables
}

resource "aws_api_gateway_rest_api" "gateway" {
  name        = var.api_name
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.gateway.id
  parent_id   = aws_api_gateway_rest_api.gateway.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.gateway.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = var.http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.gateway.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda_function.invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
   rest_api_id   = aws_api_gateway_rest_api.gateway.id
   resource_id   = aws_api_gateway_rest_api.gateway.root_resource_id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.gateway.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda_function.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.gateway.id
  stage_name  = var.stage_name
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.gateway.execution_arn}/*/*"
}