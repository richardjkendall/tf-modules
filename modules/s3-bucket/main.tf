/*
title: s3-bucket
desc: Creates an S3 bucket with some sensible defaults
*/

resource "aws_s3_bucket" "s3_bucket" {
  bucket_prefix = var.bucket_prefix
  acl           = "private"
  force_destroy = true

  dynamic "server_side_encryption_configuration" {
    for_each = var.encrypt_bucket == true ? [ "blah" ] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
      }
    }
  }

  dynamic "logging" {
    for_each = var.access_log_bucket != "" ? [ "blah" ] : []

    content {
      target_bucket = var.access_log_bucket
      target_prefix = var.access_log_prefix
    }
  }

}

resource "aws_s3_bucket_public_access_block" "block_s3_bucket_pub_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}