lambda-function-node
======


Creates a nodejs lambda function using code in a public github repository.  Uses docker to build the deployment package.

Works with
------

* [api-lambda](../api-lambda/README.md)
* [github-status-updater](../github-status-updater/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v81 | lambda-function-node & static-site: small tweaks to get fix-cf-roots working | `da61f22`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`function_name` | `string` | name of lambda function | ``
`function_handler` | `string` | handler name for lambda function | `lambda_function.lambda_handler`
`runtime` | `string` | runtime for lambda function | `nodejs12.x`
`memory` | `number` | MB of memory for function | `256`
`timeout` | `number` | how many seconds should the function be allowed to run for | `10`
`environment_variables` | `map(string)` | map of environment variables passed to the function | `{}`
`code_repository` | `string` | code repository for the lambda function | ``
`code_branch` | `string` | branch to use from code repository | `master`
`execution_role_policies` | `list(string)` | list of arns for policies which should be attached to the lambda function execution role | ``
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

