provider "aws" {
  region = var.aws_region
}

provider "archive" {}

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

locals {
  build_vars = merge({
    REPO = var.code_repository
  }, var.build_environment)
}

resource "null_resource" "packager" {
  triggers = {
    always_run = uuid()
  }
  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/output"
  }
  provisioner "local-exec" {
    command = "find ${path.module}/output -mindepth 1 -delete "
  }
  provisioner "local-exec" {
    command = "env -u HOME > env.txt; docker run --rm --env-file env.txt -v ${abspath(path.module)}/output:/output richardjkendall/lambda-builder"
    environment = local.build_vars
  }
}

data "archive_file" "zip" {
  type = "zip"
  source_dir = "${path.module}/output/"
  output_path = "function.zip"
  depends_on = [
    null_resource.packager
  ]
}

data "aws_iam_policy_document" "assume_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com"
      ]

      type = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_permissions" {
  statement {
    sid         = ""
    effect      = "Allow"
    actions     = ["logs:CreateLogGroup"]
    resources   = [
      "arn:aws:logs::${data.aws_caller_identity.current.account_id}:*"
    ]
  }

  statement {
    sid         = ""
    effect      = "Allow"
    actions     = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources   = [
      "arn:aws:logs::${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
    ]
  }
}

resource "aws_iam_policy" "policy" {
  policy = data.aws_iam_policy_document.lambda_permissions.json
}

resource "aws_iam_role" "iam_for_lambda" {
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_basic_policy_to_lambda_role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role_policy_attachment" "execution_role_policies" {
  count       = length(var.execution_role_policies)

  role        = aws_iam_role.iam_for_lambda.name
  policy_arn  = element(var.execution_role_policies, count.index)
}


resource "aws_lambda_function" "lambda" {
  function_name       = var.function_name

  filename            = data.archive_file.zip.output_path
  source_code_hash    = data.archive_file.zip.output_base64sha256

  role                = aws_iam_role.iam_for_lambda.arn
  handler             = var.function_handler
  runtime             = var.runtime
  memory_size         = var.memory
  timeout             = var.timeout
  publish             = var.publish

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? ["blah"] : []

    content {
      variables = var.environment_variables
    }
  }

  /*environment {
    variables = var.environment_variables
  }*/
}