output "s3_bucket_name" {
  description = "The name of the bucket that was created"
  value       = aws_s3_bucket.s3_bucket.id
}

output "s3_bucket_arn" {
  description = "The arn of the bucket that was created"
  value       = aws_s3_bucket.s3_bucket.arn
}