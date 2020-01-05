# tf-modules

This is a collection of Terraform Modules I've written, all for my own use on AWS.  I've made them available for others to use in-case they are useful.

I use the GitOps pattern with atlantis and terragrunt to deploy this on AWS.  You can find more details on these components here:

* Atlantis https://www.runatlantis.io/
* Terragrunt https://terragrunt.gruntwork.io/

## Modules
Each module has its own README which explains what the module does in more detail as well as the variables the module defines.

Module | Description | Link | Release tag
--- | --- | --- | ---
atlantis-fargate | Creates an ECS cluster and fargate task to run a version of atlantis which has been modified to include terragrunt | [details](modules/atlantis-fargate/README.md) | v15
basic-cicd-s3-pipeline | Creates a CodePipeline and a CodeBuild project to build and copy content into an S3 bucket for use by a CloudFront distribution.  Also creates a webhook for GitHub to call to trigger the build. | [details](modules/basic-cicd-s3-pipeline/README.md) | v9
static-site | Creates an S3 bucket and CloudFront distribution for a static site.  Manages creation of the associated ACM SSL certificate (including approval via DNS) | [details](modules/static-site/README.md) | v8
static-site-with-cicd | Joins together the static-site and basic-cicd-s3-pipeline modules to create a static site with an associated CI/CD pipeline building from a GitHub repository | [details](modules/static-site-with-cicd/README.md) | v10
s3-redirect | Creates a simple HTTP redirect for a domain using S3 | [details](modules/s3-redirect/README.md) | v12
ecs-with-spot-fleet | Builds an ECS cluster with an associated spot fleet (using EC2 Fleet) for the ECS instances | [details](modules/ecs-with-spot-fleet/README.md) | v13
ecs-service | Creates a service running on ECS | [details](modules/ecs-service/README.md) | v16
ecs-haproxy | Deploys a service discovery aware version of haproxy on an ECS cluster | [details](modules/ecs-haproxy/README.md) | v17

## Support
If you need help please reach out in a comment / bug.  I'll do my best to get back to you.

## Contributing
Please feel free to submit pull requests with changes.  Please do not include tags, I will add these if I release new versions of the modules.