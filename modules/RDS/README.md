## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.20 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |


## Resources

| Name | Type |
|------|------|
| [aws_db_instance.terraform_db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_rds_cluster.terraform_rds_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.terraform_rds_cluster_instace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_security_group.rds_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_availability_zones.available_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_rds_engine_version.terraform_db_engine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version) | data source |
| [aws_rds_engine_version.terraform_rds_cluster_engine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version) | data source |
| [aws_vpc.default_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_db_instance"></a> [create\_db\_instance](#input\_create\_db\_instance) | n/a | `bool` | `true` | no |
| <a name="input_create_rds_cluster"></a> [create\_rds\_cluster](#input\_create\_rds\_cluster) | n/a | `bool` | `true` | no |
| <a name="input_create_rds_cluster_instance"></a> [create\_rds\_cluster\_instance](#input\_create\_rds\_cluster\_instance) | n/a | `bool` | `true` | no |
| <a name="input_db_instance"></a> [db\_instance](#input\_db\_instance) | n/a | <pre>object({<br>    engine_name             = string<br>    preferred_versions      = list(string)<br>    multi_az                = bool<br>    identifier              = string<br>    username                = string<br>    instance_class          = string<br>    storage_type            = string<br>    allocated_storage       = number<br>    max_allocated_storage   = number<br>    publicly_accessible     = bool<br>    db_name                 = string<br>    backup_retention_period = number<br>    deletion_protection     = bool<br>    skip_final_snapshot     = bool<br>  })</pre> | <pre>{<br>  "allocated_storage": 20,<br>  "backup_retention_period": 7,<br>  "db_name": "terraform",<br>  "deletion_protection": false,<br>  "engine_name": "mysql",<br>  "identifier": "terraform-db-instance",<br>  "instance_class": "db.t2.micro",<br>  "max_allocated_storage": 100,<br>  "multi_az": false,<br>  "preferred_versions": [<br>    "8.0.28",<br>    "8.0.27"<br>  ],<br>  "publicly_accessible": true,<br>  "skip_final_snapshot": true,<br>  "storage_type": "gp2",<br>  "username": "master"<br>}</pre> | no |
| <a name="input_random_password"></a> [random\_password](#input\_random\_password) | n/a | <pre>object({<br>    length           = number<br>    special          = bool<br>    override_special = string<br>  })</pre> | <pre>{<br>  "length": 16,<br>  "override_special": "!#$%&*()-_=+[]{}<>:?",<br>  "special": true<br>}</pre> | no |
| <a name="input_rds_cluster"></a> [rds\_cluster](#input\_rds\_cluster) | n/a | <pre>object({<br>    engine_name             = string<br>    preferred_versions      = list(string)<br>    cluster_identifier      = string<br>    master_username         = string<br>    database_name           = string<br>    backup_retention_period = number<br>    deletion_protection     = bool<br>    skip_final_snapshot     = bool<br>  })</pre> | <pre>{<br>  "backup_retention_period": 1,<br>  "cluster_identifier": "terraform-aurora-cluster",<br>  "database_name": "auroradb",<br>  "deletion_protection": false,<br>  "engine_name": "aurora-mysql",<br>  "master_username": "master",<br>  "preferred_versions": [<br>    "5.7.mysql_aurora.2.11.4",<br>    "5.7.mysql_aurora.2.11.3"<br>  ],<br>  "skip_final_snapshot": true<br>}</pre> | no |
| <a name="input_rds_instances"></a> [rds\_instances](#input\_rds\_instances) | n/a | `list` | <pre>[<br>  {<br>    "instance_number": "1",<br>    "instance_type": "db.t2.small"<br>  },<br>  {<br>    "instance_number": "2",<br>    "instance_type": "db.t2.small"<br>  }<br>]</pre> | no |
| <a name="input_security_ingress_rules"></a> [security\_ingress\_rules](#input\_security\_ingress\_rules) | n/a | <pre>map(object({<br>    description = string<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>{<br>  "http_rule": {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow Traffic RDS",<br>    "from_port": 3306,<br>    "protocol": "tcp",<br>    "to_port": 3306<br>  }<br>}</pre> | no |

## Outputs

No outputs.
