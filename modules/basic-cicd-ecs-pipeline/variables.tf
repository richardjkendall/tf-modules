variable "aws_region" {
  description = "region where provisioning should happen"
}

variable "cluster_name" {
  description = "name of cluster where service runs"
}

variable "service_name" {
  description = "name of ECS service"
}

variable "image_repo" {
  description = "name of image repo (ECR repo)"
}

variable "gh_username" {
  description = "GitHub username used to access your site source code repo"
}

variable "gh_secret_sm_param_name" {
  description = "name of SSM parameter where GitHub webhook secret is stored"
}

variable "gh_token_sm_param_name" {
  description = "name of SSM parameter where the GitHub Oauth token is stored"
}

variable "gh_repo" {
  description = "name of repo containing site source and buildspec.yml file"
}

variable "gh_branch" {
  default = "master"
  description = "branch of git repo to use for changes"
}

variable "build_timeout" {
  default = "5"
  description = "how long should we wait (in minutes) before assuming a build has failed"
}

variable "send_notifications" {
  type = bool
  default = false
  description = "should pipeline notifications be sent"
}

variable "sns_topic_for_notifications" {
  type = string
  description = "arn for sns topic to send notifications to"
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