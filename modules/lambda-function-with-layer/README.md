
======




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
`memory` | `number` | MB of memory for function | `256`
`timeout` | `number` | how many seconds should the function be allowed to run for | `10`
`function_environment` | `map(string)` | map of environment variables passed to the function | `{}`
`function_build_environment` | `map(string)` | map of environment variables passed to the build job | `{}`
`function_code_repository` | `string` | code repository for the lambda function | ``
`runtime` | `string` | runtime for lambda function | `python3.7`
`execution_role_policies` | `list(string)` | list of arns for policies which should be attached to the lambda function execution role | ``
`layer_code_repository` | `string` | code repository for the lambda function | ``
`layer_build_environment` | `map(string)` | map of environment variables passed to the build job | `{}`
`layer_bucket` | `string` | Name of the bucket used to store the layer file | ``

Outputs
------

|Name | Description|
--- | ---
function_arn | 
invoke_arn | 
qualified_arn | 
function_name | 

