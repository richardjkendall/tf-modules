Terraform Modules
======


This is a collection of terraform modules


Click on the links to see the details of each of the modules


This documentation is auto-generated from the terraform files using tf-auto-document.

Modules
------

|Module | Description | Link|
--- | --- | ---
alb | Creates an ALB with a linked HTTPS listener.  Designed to be used with other modules which add target groups and listener rules. | [more details](modules/alb/README.md)
api-lambda | Exposes a python lambda function as an API using API gateway.  Lambda function code must be in a public github repo. | [more details](modules/api-lambda/README.md)
atlantis-ec2 | This is a generalised version of the atlantis module which runs on EC2 backed ECS.  It is designed to work with the ecs-haproxy module to be exposed via service discovery | [more details](modules/atlantis-ec2/README.md)
atlantis-fargate | Deploys a fargate task and service running atlantis (https://www.runatlantis.io).  Can create its own ALB or work with the ALB module to add rules to an existing ALB. | [more details](modules/atlantis-fargate/README.md)
azure-clone-to-s3 | Creates an API which can be called by Azure to clone an Azure Devops repo into an S3 bucket so it can be used by tools like CodePipeline | [more details](modules/azure-clone-to-s3/README.md)
basic-cicd-ecs-pipeline | Builds a codepipeline and codebuild job attached to an ECS service to manage continious deployment as the source code in a github repository changes | [more details](modules/basic-cicd-ecs-pipeline/README.md)
basic-cicd-s3-pipeline | Builds a codepipeline and codebuild job attached to an S3 backed cloudfront distribution to deploy changes as the source code changes. | [more details](modules/basic-cicd-s3-pipeline/README.md)
basic-cicd-s3-to-s3-pipeline | Builds a codepipeline and codebuild job attached to an S3 backed cloudfront distribution to deploy changes as the source code changes.  Uses an S3 bucket as a source. | [more details](modules/basic-cicd-s3-to-s3-pipeline/README.md)
docker-registry | Deploys a docker registry on ECS and exposes via Cloudmap service discovery.  Protected by http basic auth with user details stored in a dynamodb table. | [more details](modules/docker-registry/README.md)
ecs-agent-updater | Deploys a lambda function and associated cloudwatch trigger to periodically check and update the ECS agent on ECS container instances. | [more details](modules/ecs-agent-updater/README.md)
ecs-haproxy | Deploys a version of haproxy on ECS which monitors a service discovery namespace and dynamically adds/removes backends as they change.  Can either create its own ALB or work with an existing ALB. | [more details](modules/ecs-haproxy/README.md)
ecs-service | Deploys a simple ECS service backed by a simple task.  You can pass in your own task definition if you want to achieve more complex results. | [more details](modules/ecs-service/README.md)
ecs-service-with-cicd | Builds an ECS service connected to a github reposistory and redeploys the service each time the code changes. | [more details](modules/ecs-service-with-cicd/README.md)
ecs-with-spot-fleet | Builds an EC2 based ECS clusyer backed by an EC2 instance fleet using spot instances. | [more details](modules/ecs-with-spot-fleet/README.md)
github-status-updater | Creates an SNS topic which you can attach to codepipeline instances to send notifications.  Notifications are converted to github status labels and posted to github. | [more details](modules/github-status-updater/README.md)
keycloak-postgres | Deploys an instance of JBoss Keycloak backed by a postgres database on an ECS cluster | [more details](modules/keycloak-postgres/README.md)
keycloak-postgres-rds | Deploys an instance of JBoss Keycloak backed by a postgres database running on RDS | [more details](modules/keycloak-postgres-rds/README.md)
lambda-builder | This module is unfinished.  Builds lambda function artifacts and uploads to a S3 bucket.  See https://github.com/richardjkendall/lambda-builder for details of how the function is built. | [more details](modules/lambda-builder/README.md)
lambda-function | Creates a python lambda function using code in a public github repository.  Uses docker to build the deployment package.  Also depends on jq and cut to determine if code has changed in git and a function rebuild is needed.  See https://github.com/richardjkendall/lambda-builder for details of how the function is built. | [more details](modules/lambda-function/README.md)
lambda-schedule | Creates a schedule for triggering a lambda function. | [more details](modules/lambda-schedule/README.md)
postgres-rds | Sets up a basic RDS using postgres | [more details](modules/postgres-rds/README.md)
prom-grafana | Deploys an instance of prometheus and grafana running on ECS and connected to each other.  Uses EFS to store data.  Created to help monitor haproxy. | [more details](modules/prom-grafana/README.md)
s3-redirect | Creates simple HTTP only domain redirects using S3. | [more details](modules/s3-redirect/README.md)
static-site | Deploys a simple static site on CloudFront backed by an S3 origin.  Logs access request to S3. | [more details](modules/static-site/README.md)
static-site-azure-cicd | Deploys a simple static site on CloudFront backed by an S3 origin with CICD from an azure devops repo.  Works with the azure-clone-to-s3 API. | [more details](modules/static-site-azure-cicd/README.md)
static-site-azure-cicd-oidc-auth | Deploys a simple static site on CloudFront backed by an S3 origin with CICD from azure devops and protected by OIDC based login. | [more details](modules/static-site-azure-cicd-oidc-auth/README.md)
static-site-cicd-oidc-auth | Deploys a simple static site on CloudFront backed by an S3 origin with CICD from github and protected by OIDC based login. | [more details](modules/static-site-cicd-oidc-auth/README.md)
static-site-with-cicd | Deploys a simple static site on CloudFront backed by an S3 origin with CICD from github. | [more details](modules/static-site-with-cicd/README.md)
web-jumpost | Deploys a browser based console protected behind OIDC login. | [more details](modules/web-jumphost/README.md)
web-jumpost-basic | Deploys a browser based console protected behind http basic auth using a dynamo db table to store user details. | [more details](modules/web-jumphost-basic/README.md)
webdav-server | Deploys a webdav server with files kept on an EFS mount.  Server is protected using http basic auth with user details stored in a dynamodb table. | [more details](modules/webdav-server/README.md)

