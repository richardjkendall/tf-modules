lambda-function
======


Creates a python lambda function using code in a public github repository.  Uses docker to build the deployment package.  Also depends on jq and cut to determine if code has changed in git and a function rebuild is needed.  See https://github.com/richardjkendall/lambda-builder for details of how the function is built.

Works with
------

* [api-lambda](../api-lambda/README.md)
* [github-status-updater](../github-status-updater/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v44 | lambda-function: undoing changes for lambda packaging | `6351d8`
v43 | lambda-function: trying to fix windows packaging | `142ba2`
v42 | lambda-function: trying to fix packager to work on cygwin | `7ed665`
v41 | lambda-function: changing logging IAM permissions | `fb4779`
v40 | static-site-cicd-oidc-auth: and supporting module changes | `9f9d6b`
v39 | lambda-function: making packager work on windows | `59e99a`
v38 | added docker build process for lambda-function | `599726`
v26 | added ecs-agent-updater module | `5d7d77`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`function_name` | `string` | name of lambda function | ``
`function_handler` | `string` | handler name for lambda function | `lambda_function.lambda_handler`
`runtime` | `string` | runtime for lambda function | `python3.6`
`memory` | `number` | MB of memory for function | `256`
`timeout` | `number` | how many seconds should the function be allowed to run for | `10`
`environment_variables` | `map(string)` | map of environment variables passed to the function | `{}`
`code_repository` | `string` | code repository for the lambda function | ``
`code_branch` | `string` | branch to use from code repository | `master`
`execution_role_policies` | `list(string)` | list of arns for policies which should be attached to the ECS instance role | ``
`publish` | `bool` | should we publish this lambda function, should be true for lambda@edge | `false`
`build_environment` | `map(string)` | map of environment variables passed to the build job | `{}`

Outputs
------

|Name | Description|
--- | ---
function_arn | 
invoke_arn | 
qualified_arn | 
function_name | 

