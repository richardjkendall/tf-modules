lambda-function
======


Creates a python lambda function using code in a public github repository.  Uses docker to build the deployment package.  See https://github.com/richardjkendall/lambda-builder for details of how the function is built.

Works with
------

* [api-lambda](../api-lambda/README.md)
* [github-status-updater](../github-status-updater/README.md)



Releases
------


There have been no releases yet for this module

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

