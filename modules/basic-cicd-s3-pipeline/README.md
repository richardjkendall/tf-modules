basic-cicd-s3-pipeline
======


Builds a codepipeline and codebuild job attached to an S3 backed cloudfront distribution to deploy changes as the source code changes.

Works with
------

* [static-site](../static-site/README.md)
* [github-status-updater](../github-status-updater/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v67 | Merge branch 'master' of https://github.com/richardjkendall/tf-modules | `e522a91`
v59 | cicd: fix notify name has to be unique, take 2 | `2506d0e`
v58 | cicd: fix notify name has to be unique | `caad564`
v55 | static-site-with-cicd: adding support for sending notifications | `67d8541`
v47 | basic-cicd-s3-pipeline: added newer version of build image | `c2b2478`
v46 | basic-cicd-s3-pipeline: added support for build job to become root | `001e53e`
v45 | static-site: adding s3 bucket encryption support | `c383f32`
v40 | static-site-cicd-oidc-auth: and supporting module changes | `9f9d6b3`
v11 | more variables description updates | `1fd416d`
v10 | added static site with cicd + small fixes to other modules | `8c85c6b`
v9 | further changes to cicd module | `9599183`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `not specified` | region where provisioning should happen | ``
`gh_username` | `not specified` | GitHub username used to access your site source code repo | ``
`gh_secret_sm_param_name` | `not specified` | name of SSM parameter where GitHub webhook secret is stored | ``
`gh_token_sm_param_name` | `not specified` | name of SSM parameter where the GitHub Oauth token is stored | ``
`gh_repo` | `not specified` | name of repo containing site source and buildspec.yml file | ``
`gh_branch` | `not specified` | branch of git repo to use for changes | `master`
`site_name` | `not specified` | FQDN of site e.g. www.example.com | ``
`cf_distribution` | `not specified` | ID of the CF distribution to be updated on each deployment | ``
`s3_bucket` | `not specified` | S3 bucket where the files behind the CF distribution are placed | ``
`build_timeout` | `not specified` | how long should we wait (in minutes) before assuming a build has failed | `5`
`cf_invalidate` | `not specified` | should the CF distribution be invalidated for each deployment | `yes`
`encrypt_buckets` | `bool` | encrypt buckets with default AWS keys | `false`
`allow_root` | `bool` | allow build process to become root (sudo) | `false`
`build_image` | `string` | what build image should be used to run the build job | `aws/codebuild/standard:2.0`
`send_notifications` | `bool` | should pipeline notifications be sent | `false`
`sns_topic_for_notifications` | `string` | arn for sns topic to send notifications to | ``
`notifications_to_send` | `list(string)` | which notifications should we send, for values see here https://docs.aws.amazon.com/codestar-notifications/latest/userguide/concepts.html#concepts-api | `[codepipeline-pipeline-pipeline-execution-failed, codepipeline-pipeline-pipeline-execution-canceled, codepipeline-pipeline-pipeline-execution-started, codepipeline-pipeline-pipeline-execution-resumed, codepipeline-pipeline-pipeline-execution-succeeded, codepipeline-pipeline-pipeline-execution-superseded]`

Outputs
------

|Name | Description|
--- | ---
webhook_url | 

