/*
title: postgres-rds
desc: Sets up a basic RDS using postgres
*/

terraform {
  backend "s3" {}
}

resource "aws_db_instance" "db" {
    engine          = "postgres"
    engine_version  = var.postgres_version

    name        = var.database_name
    username    = var.database_user
    password    = var.database_password

    instance_class      = var.instance_class
    allocated_storage   = var.storage_size
    storage_type        = var.storage_type
    storage_encrypted   = true
    multi_az            = var.multi_az

    vpc_security_group_ids = [
        aws_security_group.allow_pg_in.id
    ]

    publicly_accessible = false

    skip_final_snapshot = true
}

resource "aws_security_group" "allow_pg_in" {
    description = "allow PG inbound"
    vpc_id      = var.vpc_id

    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        security_groups = [
            var.allowed_ingress_group
        ]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}