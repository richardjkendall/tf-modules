variable "aws_region" {
  description = "region where provisioning should happen"
  type = string
}

variable "sitename_prefix" {
  description = "prefix of site name e.g. for www.example.com this would be www"
  type = string
}

variable "domain_root" {
  description = "domain root for site e.g. example.com.  This must be available in Route53."
  type = string
}

variable "access_log_bucket" {
  description = "S3 bucket where access logs will be placed"
  type = string
}

variable "access_log_prefix" {
  description = "prefix used for any access logs written to S3"
  type = string
}

variable "viewer_req_edge_lambda_arns" {
  type = list(string)
  default = []
  description = "list of qualified arns or viewer request edge lambdas which should be placed on the distribution, should all be in us-east-1"
}

variable "encrypt_buckets" {
  type = bool
  default = false
  description = "encrypt buckets with default AWS keys"
}

variable "allow_root" {
  type = bool
  default = false
  description = "allow build process to become root (sudo)"
}

variable "build_image" {
  type = string
  default = "aws/codebuild/standard:2.0"
  description = "what build image should be used to run the build job"
}

variable "source_s3_bucket" {
  description = "S3 bucket which is the source for the build process"
  type = string
}

variable "source_s3_prefix" {
  description = "S3 bucket prefix used for the source build zip file"
  type = string
}

variable "fix_non_specific_paths" {
  type = bool
  default = false
  description = "should we apply a lambda@edge function on origin requests to fix paths which are missing the expected root object?"
}

variable "custom_404_path" {
  type = string
  default = "none"
  description = "what path should we use for a custom 404 (not found) error page"
}

variable "certificate_arn" {
  type = string
  default = ""
  description = "arn of a certificate, if this is specified the module will not create a certificate"
}

variable "alternative_dns_names" {
  type = list(string)
  default = []
  description = "list of additional names the cloudfront distribution"
}

variable "origin_access_log_bucket" {
  type = string
  default = ""
  description = "bucket to be used for access logging on the origin s3 bucket"
}

variable "origin_access_log_prefix" {
  type = string
  default = ""
  description = "prefix to use for access logs where that is enabled"
}

variable "pipeline_access_log_bucket" {
  type = string
  default = ""
  description = "bucket to be used for access logging on the origin s3 bucket"
}

variable "pipeline_access_log_prefix" {
  type = string
  default = ""
  description = "prefix to use for access logs where that is enabled"
}

variable "build_role_policies" {
  description = "list of ARNs of policies to attach to the build role"
  default = []
  type = list(string)
}