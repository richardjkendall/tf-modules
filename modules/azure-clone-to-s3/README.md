azure-clone-to-s3
======


Creates an API which can be called by Azure to clone an Azure Devops repo into an S3 bucket so it can be used by tools like CodePipeline

Depends on
------

* [api-lambda](../api-lambda/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v95 | azure-clone-to-s3: enabling logging support on the s3 buckets | `bfdd4d1`
v71 | azure-clone-to-s3: adding cloudtrail | `8cf3d54`
v68 | azure-clone-to-s3: enabled versioning on bucket | `49146d5`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`encrypt_buckets` | `bool` | encrypt buckets with default AWS keys | `false`
`api_username` | `string` | what username should be expected for basic auth user | `builduser`
`azure_devops_git_username` | `string` | username to connect to git repos on Azure Devops | ``
`api_password_ssm_param` | `string` | name of ssm parameter where basic auth password expected by the API is stored, should be a SecureString | ``
`azure_devops_git_token_ssm_param` | `string` | name of ssm parameter where the token with read access to Azure devops repos is stored, should be a SecureString | ``
`access_log_bucket` | `string` | bucket to be used for access logging on the s3 buckets created by the module | ``
`build_access_log_prefix` | `string` | prefix to use for source code bucket access logs where that is enabled | ``
`cloudtrail_access_log_prefix` | `string` | prefix to use for pipeline bucket access logs where that is enabled | ``

Outputs
------

|Name | Description|
--- | ---
webhook_url | 
bucket | 

