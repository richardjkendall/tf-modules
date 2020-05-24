/*
title: lambda-builder
desc: This module is unfinished.  Builds lambda function artifacts and uploads to a S3 bucket.  See https://github.com/richardjkendall/lambda-builder for details of how the function is built.
partners: lambda-function
*/

provider "aws" {
  region = var.aws_region
}

provider "archive" {}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "remote" {
  backend = "local"

  /*config = {
    region = var.aws_region
  }*/

  defaults = {
    build_ref = ""
  }
}

locals {
  build_vars = merge({
    REPO = var.code_repository
  }, var.build_environment)

  trigger = var.always_build ? uuid() : data.external.check_sha.result["sha"]

  s3_prefix = var.s3_prefix == "" ? "" : "${var.s3_prefix}/"

  package_file = "${path.module}/${var.function_name}/function-${var.function_name}.zip"

  remote_key = "${local.s3_prefix}${var.function_name}/${local.trigger}/package.zip"
}

data "external" "check_sha" {
  program = ["bash", "${path.module}/checkhead.sh"]

  query = {
    repo   = var.code_repository
    branch = var.code_branch
  }
}

resource "null_resource" "packager" {
  triggers = {
    build = local.trigger
  }
  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/${var.function_name}/output"
  }
  provisioner "local-exec" {
    command = "find ${path.module}/${var.function_name}/output -mindepth 1 -delete "
  }
  provisioner "local-exec" {
    command = "env -u HOME > env-${var.function_name}.txt; docker run --rm --env-file env-${var.function_name}.txt -v ${abspath(path.module)}/${var.function_name}/output:/output richardjkendall/lambda-builder"
    environment = local.build_vars
  }
  provisioner "local-exec" {
    command = "zip -r -X \"${local.package_file}\" \"${path.module}/${var.function_name}/output\" "
  }
}

resource "aws_s3_bucket_object" "upload" {
  depends_on = [null_resource.packager]
  count = local.trigger != data.terraform_remote_state.remote.outputs.build_ref ? 1 : 0

  bucket = var.s3_bucket
  key    = local.remote_key
  source = local.package_file

  etag   = filemd5(local.package_file)
}