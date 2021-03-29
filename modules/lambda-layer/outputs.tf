output "layer_arn" {
    description = "ARN of the layer that is created"
    value = aws_lambda_layer_version.lambda_layer.arn
}