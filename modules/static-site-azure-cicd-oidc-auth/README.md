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


There have been no releases yet for this module

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

