basic-cicd-s3-to-s3-pipeline
======


Builds a codepipeline and codebuild job attached to an S3 backed cloudfront distribution to deploy changes as the source code changes.  Uses an S3 bucket as a source.

Works with
------

* [static-site](../static-site/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v100 | static-site-azure*: adding support for custom build policies | `a7a18d7`
v69 | static-site-azure-cicd: added first version | `50a0fb7`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`site_name` | `string` | FQDN of site e.g. www.example.com | ``
`cf_distribution` | `string` | ID of the CF distribution to be updated on each deployment | ``
`source_s3_bucket` | `string` | S3 bucket which is the source for the build process | ``
`source_s3_prefix` | `string` | S3 bucket prefix used for the source build zip file | ``
`s3_bucket` | `string` | S3 bucket where the files behind the CF distribution are placed | ``
`build_timeout` | `string` | how long should we wait (in minutes) before assuming a build has failed | `5`
`cf_invalidate` | `string` | should the CF distribution be invalidated for each deployment | `yes`
`encrypt_buckets` | `bool` | encrypt buckets with default AWS keys | `false`
`allow_root` | `bool` | allow build process to become root (sudo) | `false`
`build_image` | `string` | what build image should be used to run the build job | `aws/codebuild/standard:2.0`
`access_log_bucket` | `string` | bucket to be used for access logging on the pipeline s3 bucket | ``
`access_log_prefix` | `string` | prefix to use for pipeline bucket access logs where that is enabled | ``
`build_role_policies` | `list(string)` | list of ARNs of policies to attach to the build role | `[]`
`build_environment` | `list(object({name=string,value=string}))` | non secret build environment variables | `[]`

