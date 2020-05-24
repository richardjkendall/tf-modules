lambda-builder
======


This module is unfinished.  Builds lambda function artifacts and uploads to a S3 bucket.  See https://github.com/richardjkendall/lambda-builder for details of how the function is built.

Works with
------

* [lambda-function](../lambda-function/README.md)



Releases
------


There have been no releases yet for this module

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`function_name` | `string` | name of lambda function | ``
`code_repository` | `string` | code repository for the lambda function | ``
`code_branch` | `string` | branch to use from code repository | `master`
`build_environment` | `map(string)` | map of environment variables passed to the build job | `{}`
`always_build` | `bool` | should we always build or only build when the source code has changed | `false`
`s3_bucket` | `string` | s3 bucket where deployable assets are placed | ``
`s3_prefix` | `string` | prefix for the assets placed in the s3 bucket | ``

Outputs
------

|Name | Description|
--- | ---
build_ref | id of build, used to determine if a rebuild should happen
remote_key | remote key for file uploaded to s3

