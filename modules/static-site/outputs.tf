output "ssl_cert_arn" {
    value = "${aws_acm_certificate.endpoint_cert.arn}"
}

output "cf_origin_s3_bucket_id" {
    value = "${aws_s3_bucket.cf_origin_s3_bucket.id}"
}

output "cf_distribution_id" {
    value = "${aws_cloudfront_distribution.cdn.id}"
}