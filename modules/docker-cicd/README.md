docker-cicd
======


Builds docker images when source code changes, depends on buildspec.yml for specific instructions on what do to to perform the build.

Releases
------


There have been no releases yet for this module

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`gh_username` | `string` | GitHub username used to access your site source code repo | ``
`gh_secret_sm_param_name` | `string` | name of SSM parameter where GitHub webhook secret is stored | ``
`gh_token_sm_param_name` | `string` | name of SSM parameter where the GitHub Oauth token is stored | ``
`ecr_repo_name` | `string` | name of the ECR repo for the images once built | ``
`gh_repo` | `string` | name of repo containing site source and buildspec.yml file | ``
`gh_branch` | `string` | branch of git repo to use for changes | `master`
`build_timeout` | `string` | how long should we wait (in minutes) before assuming a build has failed | `20`
`encrypt_buckets` | `bool` | encrypt buckets with default AWS keys | `false`
`allow_root` | `bool` | allow build process to become root (sudo) | `false`
`build_image` | `string` | what build image should be used to run the build job | `aws/codebuild/standard:2.0`
`send_notifications` | `bool` | should pipeline notifications be sent | `false`
`sns_topic_for_notifications` | `string` | arn for sns topic to send notifications to | ``
`notifications_to_send` | `list(string)` | which notifications should we send, for values see here https://docs.aws.amazon.com/codestar-notifications/latest/userguide/concepts.html#concepts-api | `[codepipeline-pipeline-pipeline-execution-failed, codepipeline-pipeline-pipeline-execution-canceled, codepipeline-pipeline-pipeline-execution-started, codepipeline-pipeline-pipeline-execution-resumed, codepipeline-pipeline-pipeline-execution-succeeded, codepipeline-pipeline-pipeline-execution-superseded]`
`build_environment` | `list(object({name=string,value=string}))` | non secret environment variables | `[]`
`build_secrets` | `list(object({name=string,valueFrom=string}))` | secret environment variables taken from parameter store | `[]`

Outputs
------

|Name | Description|
--- | ---
webhook_url | 

