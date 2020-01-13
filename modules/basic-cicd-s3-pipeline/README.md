# Basic CICD S3 Pipeline

## Description

Designed to work with the Static Site module, this module builds a CodePipeline and CodeBuild project which builds and deploys static sites into S3 buckets which act as origins for CloudFront distributions

## Versions

|Release Tag|Description|
|---|---|
|v10|Initial release of module

## Variables

|Variable|Description|Default|
|---|---|---|
|aws_region|Region where the static site will be deployed|n/a
|gh_username|Username used to access GitHub|n/a
|gh_secret_sm_param_name|Name of SSM parameter where GitHub webhook secret is stored|n/a
|gh_token_sm_param_name|Name of SSM parameter where the GitHub Oauth token is stored|n/a
|gh_repo|Name of repo containing site source and buildspec.yml file|n/a
|gh_branch|Branch of git repo to use for changes|master
|site_name|FQDN of site e.g. www.example.com|n/a
|cf_distribution|ID of the CloudFront distribution to be updated on each deployment|n/a
|s3_bucket|S3 bucket where the files behind the CF distribution are placed|n/a
|build_timeout|How long should we wait (in minutes) before assuming a build has failed|5
|cf_invalidate|Should the CF distribution be invalidated for each deployment|yes

## buildspec.yml

In order to build and deploy your code repository needs to have a file called ``buildspec.yml`` in it.  The CodeBuild project exposes the following variables which can be used by the file:

|Variable|Content|
|---|---|
|TARGET_BUCKET|ID of the S3 bucket where the files should be placed
|INVALIDATE|Should the CloudFront distribution be invalidated or not?  Values either yes or no
|DISTRIBUTION_ID|ID of the CloudFront distribution

### Example buildspec.yml

```yaml
version: 0.2
phases:
  install:
    commands:
      - echo "install step"
  pre_build:
    commands:
      - echo "any prebuild actvities"
  build:
    commands:
      - echo ${TARGET_BUCKET}
      - cd website-content
      - aws s3 sync . s3://${TARGET_BUCKET} --delete
  post_build:
    commands:
      - echo "update cloudfront distribution"
      - aws cloudfront create-invalidation --distribution-id "${DISTRIBUTION_ID}" --paths "/index.html" "/*" "/fonts/*" "/images/*" "/javascript/*" "/stylesheets/*"
```

There is comprehensive documentation on these files available here: https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html