# S3 Redirect

## Description

Creates an S3 bucket where all requests to the S3 Webserver are redirected to a domain of your choice.  Designed to implement simple domain based redirects e.g. example.com to www.example.com.

## Versions

|Release Tag|Description|
|---|---|
|v12|Initial release of module

## Variables

|Variable|Description|Default|
|---|---|---|
|aws_region|Region where the static site will be deployed|n/a
|sitename_prefix|Prefix of site name e.g. for www.example.com this would be www|n/a
|domain_root|Domain root for site e.g. for www.example.com this would be example.com.  This must be available in Route53.|n/a
|redirect_target_domain|Domain to use for redirect|n/a
|redirect_protocol|Protocol to use for redirect|https