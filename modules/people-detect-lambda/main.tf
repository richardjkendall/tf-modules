/*
title: people-detect-lambda
desc: Deploys a lambda function which when triggered by S3 ObjectCreated notifications scans the images for people and saves updated image files with bounding boxes drawn around the people.
depends: lambda-function-with-layer
*/

terraform {
  backend "s3" {}
}

data "aws_iam_policy_document" "lambda_function_policy" {
  statement {
    sid = "1"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.image_source_bucket}",
      "arn:aws:s3:::${var.image_output_bucket}"
    ]
  }

  statement {
      sid = "2"
      effect = "Allow"

      actions = [
        "s3:GetObject"
      ]

      resources = [
        "arn:aws:s3:::${var.image_source_bucket}/*"
      ]
  }

  statement {
      sid = "3"
      effect = "Allow"

      actions = [
        "s3:PutObject"
      ]

      resources = [
        "arn:aws:s3:::${var.image_source_bucket}/*"
      ]
  }
}

resource "aws_iam_policy" "lambda_function_policy" {
  policy = data.aws_iam_policy_document.lambda_function_policy.json
}

module "lambda" {
  source = "../lambda-function-with-layer"
  
  aws_region       = var.aws_region
  function_name    = "detect-person-s3"
  function_handler = "detect.lambda_handler"
  memory           = 512
  timeout          = 60
 
  function_environment = {
    OUTPUT_BUCKET = var.image_output_bucket
    OUTPUT_KEY    = var.image_output_key
  }

  execution_role_policies = [
    aws_iam_policy.lambda_function_policy.arn
  ]

  function_code_repository = "https://github.com/richardjkendall/detect-person.git"
  layer_code_repository    = "https://github.com/richardjkendall/opencv-lambda-layer.git"
  layer_bucket             = "rjk-lambda-builds"
}

data "aws_s3_bucket" "source_bucket" {
  bucket = var.image_source_bucket
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.source_bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = data.aws_s3_bucket.source_bucket.id

  dynamic "lambda_function" {
    for_each = var.input_rules

    content {
      lambda_function_arn = module.lambda.function_arn
      events              = ["s3:ObjectCreated:*"]
      filter_prefix       = lambda_function.value["prefix"]
      filter_suffix       = lambda_function.value["suffix"]
    }
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}