variable "encrypt_bucket" {
  type = bool
  description = "Should we encrypt the bucket contents, defaults to true"
  default = true
}

variable "bucket_prefix" {
  type = string
  description = "Name to prefix the bucket with"
}

variable "access_log_bucket" {
  type = string
  description = "Name of the bucket to put access logs in, if blank access logging is disabled"
  default = ""
}

variable "access_log_prefix" {
  type = string
  description = "Prefix for access logging if enabled"
  default = ""
}