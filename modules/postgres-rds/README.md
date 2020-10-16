postgres-rds
======


Sets up a basic RDS using postgres

Releases
------

|Tag | Message | Commit|
--- | --- | ---
v77 | keycloak-postgres-rds: new module and supporting modules added | `b0c0643`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`vpc_id` | `string` | vpc where DB should be created | ``
`postgres_version` | `string` | version of postgres to use | `12.3`
`database_name` | `string` | name of the database to create | ``
`database_user` | `string` | username for root account | ``
`database_password` | `string` | password for root account | ``
`storage_size` | `number` | number of GB of storage which is allocated | `10`
`storage_type` | `string` | type of storage used for database | `gp2`
`instance_class` | `string` | what class of underlying instances should be used | `db.t3.small`
`allowed_ingress_group` | `string` | security group containing instances which can communicate with the database instance | ``
`multi_az` | `bool` | should the database be deployed across multiple AZs | `false`

Outputs
------

|Name | Description|
--- | ---
db_host | 

