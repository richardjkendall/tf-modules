# Static Site

## Description

Builds a CloudFront distribution using an S3 bucket as an origin.  Creates an SSL certificate for it and enables HTTPS and HTTP to HTTPS redirect.  Enables logging to an S3 bucket.

## Versions

|Release Tag|Description|
|---|---|
|v10|Initial release of module

## Variables

|Variable|Description|Default|
|---|---|---|
|aws_region|Region where the static site will be deployed|n/a
|sitename_prefix|Prefix of site name e.g. for www.example.com this would be www|n/a
|domain_root|Domain root for site e.g. for www.example.com this would be example.com.  This must be available in Route53.|n/a
|access_log_bucket|Which S3 bucket should be used for saving CloudFront access logs|n/a
|access_log_prefix|What prefix should be used for the logs saved in S3|n/a
|http_version|What version of HTTP should the CloudFront distribution use?|http2
|root_object_location|What is the name of the root object that CloudFront will use?|index.html
|price_class|What price class should CloudFront use for the distribution?|PriceClass_All
|default_ttl|Default amount of time (in seconds) that an object is in a CloudFront cache|60
|min_ttl|Minimum amount of time that you want objects to stay in CloudFront caches|0
|max_ttl|Maximum amount of time (in seconds) that an object is in a CloudFront cache|3600