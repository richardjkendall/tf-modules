/*
title: lambda-function
desc: Creates a python lambda function using code in a public github repository.  Uses docker to build the deployment package.  Also depends on jq and cut to determine if code has changed in git and a function rebuild is needed.  See https://github.com/richardjkendall/lambda-builder for details of how the function is built.
partners: lambda-function
*/

data "aws_caller_identity" "current" {}

locals {
  build_vars = merge({
    REPO = var.code_repository
  }, var.build_environment)
}

resource "null_resource" "packager" {
  triggers = {
    trigger = uuid()
  }
  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/${var.layer_name}/output"
  }
  provisioner "local-exec" {
    command = "find ${path.module}/${var.layer_name}/output -mindepth 1 -delete "
  }
  provisioner "local-exec" {
    command = "env -u HOME > env-${var.layer_name}.txt; docker run --rm --env-file env-${var.layer_name}.txt -v ${abspath(path.module)}/${var.layer_name}/output:/output richardjkendall/lambda-layer-builder"
    environment = local.build_vars
  }
}

data "archive_file" "zip" {
  type = "zip"
  source_dir = "${path.module}/${var.layer_name}/output/"
  output_path = "layer-${var.layer_name}.zip"
  depends_on = [
    null_resource.packager
  ]
}

data "aws_s3_bucket" "layer_bucket" {
  bucket = var.layer_bucket
}

resource "aws_s3_bucket_object" "layer_object" {
  bucket = var.layer_bucket
  key    = "${var.layer_name}/layer-${var.layer_name}.zip"
  source = data.archive_file.zip.output_path
}

resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name = var.layer_name
  s3_bucket  = var.layer_bucket
  s3_key     = aws_s3_bucket_object.layer_object.id

  compatible_runtimes = [ var.runtime ]
}