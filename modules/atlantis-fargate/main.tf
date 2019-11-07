provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.ecs_cluster_name}"
}

resource "aws_ecs_task_definition" "task" {
  family                = "${var.task_def_name}"

  container_definitions = "${templatefile("atlantis.json", {
    gh_user           = "${var.gh_user}"
    whitelist         = "${var.gh_repo_whitelist}"
    url               = "https://${var.host_name}.${var.root_domain}"
    iam_role          = ""
    repoconfig        = "${jsonencode(file("repoconfig.json"))}"
    gh_webook_secret  = "${var.gh_webhook_secret_name}"
  })}"
}

// templatefile("${path.module}/backends.tmpl",