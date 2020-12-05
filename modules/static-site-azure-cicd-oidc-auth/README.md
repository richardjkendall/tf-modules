static-site-azure-cicd-oidc-auth
======


Deploys a simple static site on CloudFront backed by an S3 origin with CICD from azure devops and protected by OIDC based login.

Depends on
------

* [static-site-azure-cicd](../static-site-azure-cicd/README.md)
* [lambda-function](../lambda-function/README.md)



Works with
------

* [azure-clone-to-s3](../azure-clone-to-s3/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v100 | static-site-azure*: adding support for custom build policies | `a7a18d7`
v99 | static-site-*-oidc: adding support to manually set redirect URL if needed | `5cabe0b`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`sitename_prefix` | `string` | prefix of site name e.g. for www.example.com this would be www | ``
`domain_root` | `string` | domain root for site e.g. example.com.  This must be available in Route53. | ``
`access_log_bucket` | `string` | S3 bucket where access logs will be placed | ``
`access_log_prefix` | `string` | prefix used for any access logs written to S3 | ``
`encrypt_buckets` | `bool` | encrypt buckets with default AWS keys | `false`
`allow_root` | `bool` | allow build process to become root (sudo) | `false`
`build_image` | `string` | what build image should be used to run the build job | `aws/codebuild/standard:2.0`
`source_s3_bucket` | `string` | S3 bucket which is the source for the build process | ``
`source_s3_prefix` | `string` | S3 bucket prefix used for the source build zip file | ``
`keycloak_host` | `string` | name of keycloak host | ``
`realm` | `string` | keycloak auth realm | ``
`client_id` | `string` | client ID for keycloak client | ``
`client_secret` | `string` | client secret for keycloak client | ``
`auth_cookie_name` | `string` | name of cookie used to hold auth token | `auth`
`refresh_cookie_name` | `string` | name of cookie used to hold refresh token | `rt`
`val_api_url` | `string` | URL for JWT validation API | ``
`fix_non_specific_paths` | `bool` | should we apply a lambda@edge function on origin requests to fix paths which are missing the expected root object? | `false`
`custom_404_path` | `string` | what path should we use for a custom 404 (not found) error page | `none`
`certificate_arn` | `string` | arn of a certificate, if this is specified the module will not create a certificate | ``
`alternative_dns_names` | `list(string)` | list of additional names the cloudfront distribution | `[]`
`origin_access_log_bucket` | `string` | bucket to be used for access logging on the origin s3 bucket | ``
`origin_access_log_prefix` | `string` | prefix to use for access logs where that is enabled | ``
`pipeline_access_log_bucket` | `string` | bucket to be used for access logging on the origin s3 bucket | ``
`pipeline_access_log_prefix` | `string` | prefix to use for access logs where that is enabled | ``
`oidc_redirect_url` | `string` | if you want to override the automatically determined by the module then set this variable | ``
`build_role_policies` | `list(string)` | list of ARNs of policies to attach to the build role | `[]`
`build_environment` | `list(object({name=string,value=string}))` | non secret build environment variables | `[]`

