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

|Tag | Message | Commit|
--- | --- | ---
v112 | static*: adding further support for custom domains/certs | `bc50e5c`
v111 | static-site-cicd*: adding build environment and policy support | `acfb3c3`
v107 | adding support for static sites at domain apex | `57ea984`
v55 | static-site-with-cicd: adding support for sending notifications | `67d8541`
v46 | basic-cicd-s3-pipeline: added support for build job to become root | `001e53e`
v45 | static-site: adding s3 bucket encryption support | `c383f32`
v40 | static-site-cicd-oidc-auth: and supporting module changes | `9f9d6b3`
v11 | more variables description updates | `1fd416d`
v10 | added static site with cicd + small fixes to other modules | `8c85c6b`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`sitename_prefix` | `string` | prefix of site name e.g. for www.example.com this would be www, can be empty if deploy_at_apex is true | ``
`deploy_at_apex` | `bool` | Deploy site at the domain_root apex, defaults to false | `false`
`domain_root` | `string` | domain root for site e.g. example.com.  This must be available in Route53. | ``
`access_log_bucket` | `string` | S3 bucket where access logs will be placed | ``
`access_log_prefix` | `string` | prefix used for any access logs written to S3 | ``
`gh_username` | `string` | GitHub username used to access your site source code repo | ``
`gh_secret_sm_param_name` | `string` | name of SSM parameter where GitHub webhook secret is stored | ``
`gh_token_sm_param_name` | `string` | name of SSM parameter where the GitHub Oauth token is stored | ``
`gh_repo` | `string` | name of repo containing site source and buildspec.yml file | ``
`gh_branch` | `not specified` | branch of git repo to use for changes | `master`
`viewer_req_edge_lambda_arns` | `list(string)` | list of qualified arns or viewer request edge lambdas which should be placed on the distribution, should all be in us-east-1 | `[]`
`encrypt_buckets` | `bool` | encrypt buckets with default AWS keys | `false`
`allow_root` | `bool` | allow build process to become root (sudo) | `false`
`send_notifications` | `bool` | should pipeline notifications be sent | `false`
`sns_topic_for_notifications` | `string` | arn for sns topic to send notifications to | ``
`notifications_to_send` | `list(string)` | which notifications should we send, for values see here https://docs.aws.amazon.com/codestar-notifications/latest/userguide/concepts.html#concepts-api | `[codepipeline-pipeline-pipeline-execution-failed, codepipeline-pipeline-pipeline-execution-canceled, codepipeline-pipeline-pipeline-execution-started, codepipeline-pipeline-pipeline-execution-resumed, codepipeline-pipeline-pipeline-execution-succeeded, codepipeline-pipeline-pipeline-execution-superseded]`
`build_image` | `string` | what build image should be used to run the build job | `aws/codebuild/standard:2.0`
`fix_non_specific_paths` | `bool` | should we apply a lambda@edge function on origin requests to fix paths which are missing the expected root object? | `false`
`custom_404_path` | `string` | what path should we use for a custom 404 (not found) error page | `none`
`origin_access_log_bucket` | `string` | bucket to be used for access logging on the origin s3 bucket | ``
`origin_access_log_prefix` | `string` | prefix to use for access logs where that is enabled | ``
`pipeline_access_log_bucket` | `string` | bucket to be used for access logging on the origin s3 bucket | ``
`pipeline_access_log_prefix` | `string` | prefix to use for access logs where that is enabled | ``
`build_role_policies` | `list(string)` | list of ARNs of policies to attach to the build role | `[]`
`build_environment` | `list(object({name=string,value=string}))` | non secret build environment variables | `[]`
`build_compute_type` | `string` | compute type for the build job | `BUILD_GENERAL1_SMALL`
`certificate_arn` | `string` | arn of a certificate, if this is specified the module will not create a certificate | ``
`alternative_dns_names` | `list(string)` | list of additional names the cloudfront distribution | `[]`

Outputs
------

|Name | Description|
--- | ---
webhook_url | 

