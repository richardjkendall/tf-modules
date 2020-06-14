output "webhook_url" {
  value = module.api.base_url
}

output "bucket" {
  value = aws_s3_bucket.build_bucket.id
}