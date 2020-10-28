static-site
======


Deploys a simple static site on CloudFront backed by an S3 origin.  Logs access request to S3.

Works with
------

* [static-site-with-cicd](../static-site-with-cicd/README.md)
* [static-site-cicd-oidc-auth](../static-site-cicd-oidc-auth/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v81 | lambda-function-node & static-site: small tweaks to get fix-cf-roots working | `da61f22`
v75 | static-site: updating to match latest aws provider for acm validation | `553a12c`
v69 | static-site-azure-cicd: added first version | `50a0fb7`
v64 | static-site-cicd-oidc-auth: adding support to change build image | `51634e9`
v55 | static-site-with-cicd: adding support for sending notifications | `67d8541`
v46 | basic-cicd-s3-pipeline: added support for build job to become root | `001e53e`
v45 | static-site: adding s3 bucket encryption support | `c383f32`
v40 | static-site-cicd-oidc-auth: and supporting module changes | `9f9d6b3`
v11 | more variables description updates | `1fd416d`
v10 | added static site with cicd + small fixes to other modules | `8c85c6b`
v8 | fixed hosted_zone_typo | `5eaa939`
v7 | fixing r53 incorrect attributes | `b3e3804`
v6 | added r53 for cf distribution | `6a514af`
v5 | adding back restrictions block | `ea8ace9`
v4 | fixed typo in r53 zone | `aa03fab`
v3 | fixed mispelled var name | `abdcb15`
v2 | fixing duplicated variable aws_region | `abd659e`
v1 | adding first go at static site module | `af683f8`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `not specified` | region where provisioning should happen | ``
`sitename_prefix` | `not specified` | prefix of site name e.g. for www.example.com this would be www | ``
`domain_root` | `not specified` | domain root for site e.g. example.com.  This must be available in Route53. | ``
`access_log_bucket` | `not specified` | S3 bucket where access logs will be placed | ``
`access_log_prefix` | `not specified` | prefix used for any access logs written to S3 | ``
`http_version` | `not specified` | version of http to use on this site | `http2`
`root_object_location` | `not specified` | name of object to show when root of site is opened in a browser | `index.html`
`price_class` | `not specified` | price class for the distribution, for more details see here https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_DistributionConfig.html | `PriceClass_All`
`default_ttl` | `not specified` | Default amount of time (in seconds) that an object is in a CloudFront cache | `60`
`min_ttl` | `not specified` | Minimum amount of time that you want objects to stay in CloudFront caches | `0`
`max_ttl` | `not specified` | Maximum amount of time (in seconds) that an object is in a CloudFront cache | `3600`
`viewer_req_edge_lambda_arns` | `list(string)` | list of qualified arns or viewer request edge lambdas which should be placed on the distribution, should all be in us-east-1 | `[]`
`encrypt_buckets` | `bool` | encrypt buckets with default AWS keys | `false`
`fix_non_specific_paths` | `bool` | should we apply a lambda@edge function on origin requests to fix paths which are missing the expected root object? | `false`
`custom_404_path` | `string` | what path should we use for a custom 404 (not found) error page | `none`

Outputs
------

|Name | Description|
--- | ---
ssl_cert_arn | 
cf_origin_s3_bucket_id | 
cf_distribution_id | 

