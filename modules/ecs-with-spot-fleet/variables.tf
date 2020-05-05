variable "aws_region" {
  description = "region where provisioning should happen"
}

variable "ecs_cluster_name" {
  description = "name of the ECS cluster created"
}

variable "instance_types" {
  type = list(string)
  description = "list of instance types to use for the fleet, first one in the list is used as the launch template instance type"
}

variable "ecs_instance_subnets" {
  type = list(string)
  description = "list of subnets in which ECS instances can be launched"
}

variable "ecs_instance_key_name" {
  description = "name of the key pair to use for the ECS instances"
}

variable "ecs_instance_security_groups" {
  type = list(string)
  description = "list of security groups applied to the ECS instances"
}

variable "ecs_instance_role_policies" {
  type = list(string)
  description = "list of arns for policies which should be attached to the ECS instance role"
}

variable "number_of_ecs_instances" {
  default = 2
  description = "number of instances to provision, default is 2"
}

variable "spot_allocation_strategy" {
  default = "lowestPrice"
  description = "allocation strategy to be used for spot instances"
}