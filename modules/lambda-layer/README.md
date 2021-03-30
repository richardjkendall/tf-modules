lambda-function
======


Creates a python lambda function using code in a public github repository.  Uses docker to build the deployment package.  Also depends on jq and cut to determine if code has changed in git and a function rebuild is needed.  See https://github.com/richardjkendall/lambda-builder for details of how the function is built.

Works with
------

* [lambda-function](../lambda-function/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v113 | lambda/people detect work | `0aa3e5b`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`layer_name` | `string` | Name of the lambda layer | ``
`runtime` | `string` | runtime for lambda function | `python3.7`
`code_repository` | `string` | code repository for the lambda function | ``
`build_environment` | `map(string)` | map of environment variables passed to the build job | `{}`
`layer_bucket` | `string` | Name of the bucket used to store the layer file | ``

Outputs
------

|Name | Description|
--- | ---
layer_arn | ARN of the layer that is created

