variable "aws_region" {
  type = string
  description = "region where provisioning should happen"
}

variable "function_name" {
  type = string
  description = "name of lambda function to be scheduled"
}

variable "schedule_expression" {
  type = string
  description = "schedule for trigger"
  default = "rate(12 hours)"
}