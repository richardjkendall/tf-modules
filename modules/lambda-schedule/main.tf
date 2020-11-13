/*
title: lambda-schedule
desc: Creates a schedule for triggering a lambda function.
partners: lambda-function
*/

terraform {
  backend "s3" {}
}

data "aws_lambda_function" "lambda" {
  function_name = var.function_name
}

resource "aws_cloudwatch_event_rule" "event_rule" {
    schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "trigger_lambda_on_event" {
    rule = aws_cloudwatch_event_rule.event_rule.name
    arn  = data.aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = data.aws_lambda_function.lambda.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.event_rule.arn
}