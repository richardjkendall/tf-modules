s3-redirect
======


Creates simple HTTP only domain redirects using S3.

Releases
------

|Tag | Message | Commit|
--- | --- | ---
v12 | added s3 redirect module | `18b7151`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `not specified` | region where provisioning should happen | ``
`sitename_prefix` | `not specified` | prefix of site name e.g. for www.example.com this would be www | ``
`domain_root` | `not specified` | domain root for site e.g. example.com.  This must be available in Route53. | ``
`redirect_target_domain` | `not specified` | domain to use for redirect | ``
`redirect_protocol` | `not specified` | protocol to use for redirect | `https`

