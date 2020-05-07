static-site
======


Deploys a simple static site on CloudFront backed by an S3 origin.  Logs access request to S3.

Works with
------

* [static-site-with-cicd](../static-site-with-cicd/README.md)
* [static-site-cicd-oidc-auth](../static-site-cicd-oidc-auth/README.md)



Releases
------


There have been no releases yet for this module

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

