static-site-with-cicd
======


Deploys a simple static site on CloudFront backed by an S3 origin with CICD from github.

Depends on
------

* [static-site](../static-site/README.md)
* [basic-cicd-s3-pipeline](../basic-cicd-s3-pipeline/README.md)



Works with
------

* [static-site-cicd-oidc-auth](../static-site-cicd-oidc-auth/README.md)



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
`viewer_req_edge_lambda_arns` | `list(string)` | list of qualified arns or viewer request edge lambdas which should be placed on the distribution, should all be in us-east-1 | `[]`
`encrypt_buckets` | `bool` | encrypt buckets with default AWS keys | `false`
`allow_root` | `bool` | allow build process to become root (sudo) | `false`
`build_image` | `string` | what build image should be used to run the build job | `aws/codebuild/standard:2.0`
`source_s3_bucket` | `string` | S3 bucket which is the source for the build process | ``
`source_s3_prefix` | `string` | S3 bucket prefix used for the source build zip file | ``

