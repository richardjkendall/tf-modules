# Atlantis Fargate

## Description

Builds an ECS cluster, fargate ECS task, ECS service, ALB and associated SSL certificate to run atlantis.

https://www.runatlantis.io

The docker image this module runs is modified from the base image.  Terragrunt has been added.  You can see more details here https://hub.docker.com/r/richardjkendall/atlantis

## Versions

|Release Tag|Description|
|---|---|
|v11|Initial release of module

## Variables

|Variable|Description|Default|
|---|---|---|
aws_region|Region where the resources should be provisioned|n/a
ecs_cluster_name|Name of the ECS cluster that will be created|atlantis
task_def_name|Name of the task definition that will be created|atlantis
root_domain|Root of domain where the endpoint will be deployed e.g. for atlantis.example.com this would be example.com|n/a
host_name|Host name for the atlantis endpoint e.g. for atlantis.example.com this would be atlantis|atlantis
gh_user|Username used to access GitHub|n/a
gh_token_secret_name|Name of the SSM Parameter where the GitHub OAuth2 token is stored|n/a
gh_repo_whitelist|What repo or repos can be used to trigger this instance of atlantis to take action e.g. github.com/blah/aws*|n/a
gh_webhook_secret_name|Name of the SSM Parameter where the GitHub webhook secret is stored|n/a
vpc_id|ID for the VPC where we will deploy|n/a
allowed_ips|List of IP ranges allowed to access the atlantis endpoint, this is only used when the GitHub meta-data API does not return a list of IP ranges*|["0.0.0.0/0"]
lb_subnets|List of subnets where the ALB will be deployed, these must have internet connectivity|n/a
task_subnets|List of subnets where the atlantis tasks will launch|n/a

## More information

### Allowed IP ranges
This Terraform module queries the GitHub meta-data API (available here https://api.github.com/meta) in order to find the IP ranges that are used to fire webhooks.

### Hard coded Atlantis config

`atlantis.json` contains the specific environment variables being passed to Atlantis on start up.  Most are taken from the config you pass into the Terraform module, but some are not.

|Variable|Value|
|---|---|
|ATLANTIS_ALLOW_REPO_CONFIG|false|

