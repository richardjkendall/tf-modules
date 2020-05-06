Terraform Modules
======

This is a collection of terraform modules
Click on the links to see the details of each of the modules
|Module | Description | Link|
--- | --- | ---
alb | Creates an ALB with a linked HTTPS listener.  Designed to be used with other modules which add target groups and listener rules. | [more details](modules/alb/README.md)
api-lambda | Exposes a python lambda function as an API using API gateway.  Lambda function code must be in a public github repo. | [more details](modules/api-lambda/README.md)
basic-cicd-ecs-pipeline | Builds a codepipeline and codebuild job attached to an ECS service to manage continious deployment as the source code in a github repository changes | [more details](modules/basic-cicd-ecs-pipeline/README.md)
basic-cicd-s3-pipeline | Builds a codepipeline and codebuild job attached to an S3 backed cloudfront distribution to deploy changes as the source code changes. | [more details](modules/basic-cicd-s3-pipeline/README.md)
docker-registry | Deploys a docker registry on ECS and exposes via Cloudmap service discovery.  Protected by http basic auth with user details stored in a dynamodb table. | [more details](modules/docker-registry/README.md)
ecs-agent-updater | Deploys a lambda function and associated cloudwatch trigger to periodically check and update the ECS agent on ECS container instances. | [more details](modules/ecs-agent-updater/README.md)
ecs-haproxy | Deploys a version of haproxy on ECS which monitors a service discovery namespace and dynamically adds/removes backends as they change.  Can either create its own ALB or work with an existing ALB. | [more details](modules/ecs-haproxy/README.md)
ecs-service | Deploys a simple ECS service backed by a simple task.  You can pass in your own task definition if you want to achieve more complex results. | [more details](modules/ecs-service/README.md)
ecs-service-with-cicd | Builds an ECS service connected to a github reposistory and redeploys the service each time the code changes. | [more details](modules/ecs-service-with-cicd/README.md)
ecs-with-spot-fleet | Builds an EC2 based ECS clusyer backed by an EC2 instance fleet using spot instances. | [more details](modules/ecs-with-spot-fleet/README.md)
lambda-function | Creates a python lambda function using code in a public github repository.  Uses docker to build the deployment package.  See https://github.com/richardjkendall/lambda-builder for details of how the function is built. | [more details](modules/lambda-function/README.md)
lambda-schedule | Creates a schedule for triggering a lambda function. | [more details](modules/lambda-schedule/README.md)
prom-grafana | Deploys an instance of prometheus and grafana running on ECS and connected to each other.  Uses EFS to store data.  Created to help monitor haproxy. | [more details](modules/prom-grafana/README.md)
s3-redirect | Creates simple HTTP only domain redirects using S3. | [more details](modules/s3-redirect/README.md)
static-site | Deploys a simple static site on CloudFront backed by an S3 origin.  Logs access request to S3. | [more details](modules/static-site/README.md)
static-site-cicd-oidc-auth | Deploys a simple static site on CloudFront backed by an S3 origin with CICD from github and protected by OIDC based login. | [more details](modules/static-site-cicd-oidc-auth/README.md)

