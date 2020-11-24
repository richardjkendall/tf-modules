variable "aws_region" {
  description = "region where provisioning should happen"
  type = string
}

variable "gh_username" {
  description = "GitHub username used to access your site source code repo"
  type = string
}

variable "gh_secret_sm_param_name" {
  description = "name of SSM parameter where GitHub webhook secret is stored"
  type = string
}

variable "gh_token_sm_param_name" {
  description = "name of SSM parameter where the GitHub Oauth token is stored"
  type = string
}

variable "ecr_repo_name" {
  description = "name of the ECR repo for the images once built"
  type = string
}

variable "gh_repo" {
  description = "name of repo containing site source and buildspec.yml file"
  type = string
}

variable "gh_branch" {
  default = "master"
  description = "branch of git repo to use for changes"
  type = string
}

variable "build_timeout" {
  default = "20"
  description = "how long should we wait (in minutes) before assuming a build has failed"
  type = string
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

variable "send_notifications" {
  type = bool
  default = false
  description = "should pipeline notifications be sent"
}

variable "sns_topic_for_notifications" {
  type = string
  description = "arn for sns topic to send notifications to"
  default = ""
}

variable "notifications_to_send" {
  type = list(string)
  description = "which notifications should we send, for values see here https://docs.aws.amazon.com/codestar-notifications/latest/userguide/concepts.html#concepts-api"
  default = [
    "codepipeline-pipeline-pipeline-execution-failed",
    "codepipeline-pipeline-pipeline-execution-canceled",
    "codepipeline-pipeline-pipeline-execution-started",
    "codepipeline-pipeline-pipeline-execution-resumed",
    "codepipeline-pipeline-pipeline-execution-succeeded",
    "codepipeline-pipeline-pipeline-execution-superseded"
  ]
} 

variable "build_environment" {
  description = "non secret environment variables"
  default = []
  type = list(object({
    name = string,
    value = string
  }))
}

variable "build_secrets" {
  description = "secret environment variables taken from parameter store"
  default = []
  type = list(object({
    name = string,
    valueFrom = string
  }))
}

variable "deploy_to_ecs" {
  description = "should the pipeline trigger an ECS deployment"
  type = bool
  default = false
}

variable "ecs_service" {
  description = "service name for ECS deployment"
  type = string
  default = ""
}

variable "ecs_cluster" {
  description = "cluster name for ECS deployment"
  type = string
  default = ""
}

variable "ecs_deploy_file" {
  description = "name of ECS deployment descriptor file"
  type = string
  default = "deploy.json"
}