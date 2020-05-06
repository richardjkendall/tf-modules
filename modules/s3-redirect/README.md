s3-redirect
======


Creates simple HTTP only domain redirects using S3.

Releases
------

|Tag | Message | Commit|
--- | --- | ---
v12 | added s3 redirect module | 18b715

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
aws_region |  | region where provisioning should happen | 
sitename_prefix |  | prefix of site name e.g. for www.example.com this would be www | 
domain_root |  | domain root for site e.g. example.com.  This must be available in Route53. | 
redirect_target_domain |  | domain to use for redirect | 
redirect_protocol |  | protocol to use for redirect | https

