output "function_arn" {
  value = aws_lambda_function.lambda.arn
}

output "invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}

output "qualified_arn" {
  value = aws_lambda_function.lambda.qualified_arn
}

output "function_name" {
  value = aws_lambda_function.lambda.function_name
}