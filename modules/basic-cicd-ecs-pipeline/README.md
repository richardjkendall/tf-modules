basic-cicd-ecs-pipeline
======


Builds a codepipeline and codebuild job attached to an ECS service to manage continious deployment as the source code in a github repository changes

Works with
------

* [ecs-service](../ecs-service/README.md)
* [github-status-updater](../github-status-updater/README.md)



Releases
------


There have been no releases yet for this module

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `not specified` | region where provisioning should happen | ``
`cluster_name` | `not specified` | name of cluster where service runs | ``
`service_name` | `not specified` | name of ECS service | ``
`image_repo` | `not specified` | name of image repo (ECR repo) | ``
`gh_username` | `not specified` | GitHub username used to access your site source code repo | ``
`gh_secret_sm_param_name` | `not specified` | name of SSM parameter where GitHub webhook secret is stored | ``
`gh_token_sm_param_name` | `not specified` | name of SSM parameter where the GitHub Oauth token is stored | ``
`gh_repo` | `not specified` | name of repo containing site source and buildspec.yml file | ``
`gh_branch` | `not specified` | branch of git repo to use for changes | `master`
`build_timeout` | `not specified` | how long should we wait (in minutes) before assuming a build has failed | `5`
`send_notifications` | `bool` | should pipeline notifications be sent | `false`
`sns_topic_for_notifications` | `string` | arn for sns topic to send notifications to | ``
`notifications_to_send` | `list(string)` | which notifications should we send, for values see here https://docs.aws.amazon.com/codestar-notifications/latest/userguide/concepts.html#concepts-api | `[codepipeline-pipeline-pipeline-execution-failed, codepipeline-pipeline-pipeline-execution-canceled, codepipeline-pipeline-pipeline-execution-started, codepipeline-pipeline-pipeline-execution-resumed, codepipeline-pipeline-pipeline-execution-succeeded, codepipeline-pipeline-pipeline-execution-superseded]`

Outputs
------

|Name | Description|
--- | ---
webhook_url | 

