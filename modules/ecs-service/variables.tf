variable "aws_region" {
  description = "region where provisioning should happen"
  type = string
}

variable "cluster_name" {
  description = "name of cluster where service will run"
  type = string
}

variable "service_name" {
  description = "name of ECS service"
  type = string
}

variable "task_def_override" {
  description = "used to override the task definition with an external task def"
  default = null
  type = any
}

variable "task_name" {
  description = "name of ECS container"
  type = string
}

variable "service_registry_id" {
  description = "ID for the AWS service discovery namespace we will use"
  type = string
  default = ""
}

variable "service_registry_service_name" {
  description = "name for service we will use in the service registry"
  type = string
  default = ""
}

variable "image" {
  description = "image task will use"
  type = string
}

variable "cpu" {
  description = "CPU units for the task"
  default = 128
  type = number
}

variable "memory" {
  description = "memory for the task"
  default = 256
  type = number
}

variable "port_mappings" {
  description = "list of port mappings for the task"
  type = list(object({
      containerPort = number
      hostPort = number
      protocol = string
  }))
}

variable "secrets" {
  description = "environment variables from secrets"
  default = []
  type = list(object({
    name = string,
    valueFrom = string
  }))
}

variable "environment" {
  description = "non scret environment variables"
  default = []
  type = list(object({
    name = string,
    value = string
  }))
}

variable "healthcheck" {
  description = "healthcheck for the container"
  default = null
  type = object({
    command = list(string),
    interval = number,
    timeout = number,
    retries = number,
    startPeriod = number
  })
}

variable "efs_volumes" {
  description = "volumes for the task"
  default = []
  type = list(object({
    name = string,
    fileSystemId = string,
    rootDirectory = string
  }))
}

variable "mount_points" {
  description = "mount points for the task definition"
  default = []
  type = list(object({
    sourceVolume = string,
    containerPath = string,
    readOnly = bool
  }))
}

variable "network_mode" {
  description = "network mode to use for tasks"
  default = "bridge"
}

variable "number_of_tasks" {
  description = "number of tasks to spawn for service"
  default = 2
  type = number
}

variable "load_balancer" {
  description = "application load balancer associated with the service"
  default = null
  type = object({
    target_group_arn = string
    container_name = string
    container_port = number
  })
}

variable "task_role_policies" {
  description = "list of ARNs of policies to attach to the task role"
  default = []
  type = list(string)
}

variable "repository_credentials_secret" {
  description = "secret for credentials to access the docker repository, needed if using a private repository"
  default = ""
  type = string
}

variable "launch_type" {
  description = "should we use EC2 or fargate"
  default = "EC2"
  type = string
}

variable "use_spot" {
  description = "use spot capacity?  only takes effect for a the fargate launch type"
  default = false
  type = bool
}

variable "fargate_task_subnets" {
  default = []
  type = list(string)
  description = "list of subnets to use for tasks launched on fargate"
}

variable "fargate_task_sec_groups" {
  default = []
  type = list(string)
  description = "list of security groups to use for tasks launched on fargate"
}