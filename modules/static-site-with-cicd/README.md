static-site-with-cicd
======


Deploys a simple static site on CloudFront backed by an S3 origin with CICD from github.

Depends on
------

* [static-site](../static-site/README.md)
* [basic-cicd-s3-pipeline](../basic-cicd-s3-pipeline/README.md)



Works with
------

* [static-site-cicd-oidc-auth](../static-site-cicd-oidc-auth/README.md)



Releases
------


There have been no releases yet for this module

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `not specified` | region where provisioning should happen | ``
`sitename_prefix` | `not specified` | prefix of site name e.g. for www.example.com this would be www | ``
`domain_root` | `not specified` | domain root for site e.g. example.com.  This must be available in Route53. | ``
`access_log_bucket` | `not specified` | S3 bucket where access logs will be placed | ``
`access_log_prefix` | `not specified` | prefix used for any access logs written to S3 | ``
`gh_username` | `not specified` | GitHub username used to access your site source code repo | ``
`gh_secret_sm_param_name` | `not specified` | name of SSM parameter where GitHub webhook secret is stored | ``
`gh_token_sm_param_name` | `not specified` | name of SSM parameter where the GitHub Oauth token is stored | ``
`gh_repo` | `not specified` | name of repo containing site source and buildspec.yml file | ``
`gh_branch` | `not specified` | branch of git repo to use for changes | `master`
`viewer_req_edge_lambda_arns` | `list(string)` | list of qualified arns or viewer request edge lambdas which should be placed on the distribution, should all be in us-east-1 | `[]`
`encrypt_buckets` | `bool` | encrypt buckets with default AWS keys | `false`
`allow_root` | `bool` | allow build process to become root (sudo) | `false`
`send_notifications` | `bool` | should pipeline notifications be sent | `false`
`sns_topic_for_notifications` | `string` | arn for sns topic to send notifications to | ``
`notifications_to_send` | `list(string)` | which notifications should we send, for values see here https://docs.aws.amazon.com/codestar-notifications/latest/userguide/concepts.html#concepts-api | `[codepipeline-pipeline-pipeline-execution-failed, codepipeline-pipeline-pipeline-execution-canceled, codepipeline-pipeline-pipeline-execution-started, codepipeline-pipeline-pipeline-execution-resumed, codepipeline-pipeline-pipeline-execution-succeeded, codepipeline-pipeline-pipeline-execution-superseded]`

