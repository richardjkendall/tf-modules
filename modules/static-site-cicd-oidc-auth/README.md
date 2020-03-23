# Static Site with CICD

## Description

Deploys a complete Static Site + CICD pipeline.  This is a combination of the static-site and basic-cicd-s3-pipeline modules in a single module.

## Versions

|Release Tag|Description|
|---|---|
|v10|Initial release of module

## Variables

|Variable|Description|Default|
|---|---|---|
|aws_region|Region where the static site will be deployed|n/a
|sitename_prefix|Prefix of site name e.g. for www.example.com this would be www|n/a
|domain_root|Domain root for site e.g. for www.example.com this would be example.com.  This must be available in Route53.|n/a
|access_log_bucket|Which S3 bucket should be used for saving CloudFront access logs|n/a
|access_log_prefix|What prefix should be used for the logs saved in S3|n/a
|gh_username|Username used to access GitHub|n/a
|gh_secret_sm_param_name|Name of SSM parameter where GitHub webhook secret is stored|n/a
|gh_token_sm_param_name|Name of SSM parameter where the GitHub Oauth token is stored|n/a
|gh_repo|Name of repo containing site source and buildspec.yml file|n/a
|gh_branch|Branch of git repo to use for changes|master

## buildspec.yml

In order to build and deploy your code repository needs to have a file called ``buildspec.yml`` in it.  The CodeBuild project exposes the following variables which can be used by the file:

|Variable|Content|
|---|---|
|TARGET_BUCKET|ID of the S3 bucket where the files should be placed
|INVALIDATE|Should the CloudFront distribution be invalidated or not?  Values either yes or no
|DISTRIBUTION_ID|ID of the CloudFront distribution

Look at the basic-cicd-s3-pipeline README to find an example buildspec.yml [here](../basic-cicd-s3-pipeline/README.md)