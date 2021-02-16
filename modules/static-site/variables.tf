variable "aws_region" {
  type = string
  description = "region where provisioning should happen"
}

variable "sitename_prefix" {
  type = string
  description = "prefix of site name e.g. for www.example.com this would be www, can be empty if deploy_at_apex is true"
  default = ""
}

variable "deploy_at_apex" {
  type = bool
  description = "Deploy site at the domain_root apex, defaults to false"
  default = false
}

variable "domain_root" {
  type = string
  description = "domain root for site e.g. example.com.  This must be available in Route53."
}

variable "access_log_bucket" {
  type = string
  description = "S3 bucket where access logs will be placed"
}

variable "access_log_prefix" {
  type = string
  description = "prefix used for any access logs written to S3"
}

variable "http_version" {
  type = string
  default = "http2"
  description = "version of http to use on this site"
}

variable "root_object_location" {
  type = string
  default = "index.html"
  description = "name of object to show when root of site is opened in a browser"
}

variable "price_class" {
  type = string
  default = "PriceClass_All"
  description = "price class for the distribution, for more details see here https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_DistributionConfig.html"
}

variable "default_ttl" {
  type = number
  default     = 60
  description = "Default amount of time (in seconds) that an object is in a CloudFront cache"
}

variable "min_ttl" {
  type = number
  default     = 0
  description = "Minimum amount of time that you want objects to stay in CloudFront caches"
}

variable "max_ttl" {
  type = number
  default     = 3600
  description = "Maximum amount of time (in seconds) that an object is in a CloudFront cache"
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