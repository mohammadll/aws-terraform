variable "create_db_instance" {
  type    = bool
  default = true
}

variable "create_rds_cluster" {
  type    = bool
  default = true
}

variable "create_rds_cluster_instance" {
  type    = bool
  default = true
}

variable "security_ingress_rules" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    http_rule = {
      description = "Allow Traffic RDS"
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "random_password" {
  type = object({
    length           = number
    special          = bool
    override_special = string
  })
  default = {
    length           = 16
    special          = true
    override_special = "!#$%&*()-_=+[]{}<>:?"
  }
}

variable "db_instance" {
  type = object({
    engine_name             = string
    preferred_versions      = list(string)
    multi_az                = bool
    identifier              = string
    username                = string
    instance_class          = string
    storage_type            = string
    allocated_storage       = number
    max_allocated_storage   = number
    publicly_accessible     = bool
    db_name                 = string
    backup_retention_period = number
    deletion_protection     = bool
    skip_final_snapshot     = bool
  })
  default = {
    engine_name             = "mysql"
    preferred_versions      = ["8.0.28", "8.0.27"]
    multi_az                = false
    identifier              = "terraform-db-instance"
    username                = "master"
    instance_class          = "db.t2.micro"
    storage_type            = "gp2"
    allocated_storage       = 20
    max_allocated_storage   = 100
    publicly_accessible     = true
    db_name                 = "terraform"
    backup_retention_period = 7
    deletion_protection     = false
    skip_final_snapshot     = true
  }
}

variable "rds_cluster" {
  type = object({
    engine_name             = string
    preferred_versions      = list(string)
    cluster_identifier      = string
    master_username         = string
    database_name           = string
    backup_retention_period = number
    deletion_protection     = bool
    skip_final_snapshot     = bool
  })
  default = {
    engine_name             = "aurora-mysql"
    preferred_versions      = ["5.7.mysql_aurora.2.11.4", "5.7.mysql_aurora.2.11.3"]
    cluster_identifier      = "terraform-aurora-cluster"
    master_username         = "master"
    database_name           = "auroradb"
    backup_retention_period = 1
    deletion_protection     = false
    skip_final_snapshot     = true
  }
}

variable "rds_instances" {
  default = [
    {
      instance_number = "1"
      instance_type   = "db.t2.small"
    },
    {
      instance_number = "2"
      instance_type   = "db.t2.small"
    },
  ]
}