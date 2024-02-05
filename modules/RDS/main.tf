locals {
  create_db_instance          = var.create_db_instance
  create_rds_cluster          = var.create_rds_cluster
  create_rds_cluster_instance = var.create_rds_cluster_instance
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_rds_engine_version" "terraform_db_engine" {
  engine             = var.db_instance["engine_name"]
  preferred_versions = var.db_instance["preferred_versions"]
}

resource "aws_security_group" "rds_sg" {
  count       = local.create_db_instance || local.create_rds_cluster ? 1 : 0
  name        = "rds-security-group"
  description = "Security group for RDS"

  vpc_id = data.aws_vpc.default_vpc.id

  dynamic "ingress" {
    for_each = var.security_ingress_rules
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_password" "password" {
  count            = local.create_db_instance || local.create_rds_cluster ? 1 : 0
  length           = var.random_password["length"]
  special          = var.random_password["special"]
  override_special = var.random_password["override_special"]
}

resource "aws_db_instance" "terraform_db_instance" {
  count                   = local.create_db_instance ? 1 : 0
  engine                  = data.aws_rds_engine_version.terraform_db_engine.engine
  engine_version          = data.aws_rds_engine_version.terraform_db_engine.version
  multi_az                = var.db_instance["multi_az"]
  identifier              = var.db_instance["identifier"]
  username                = var.db_instance["username"]
  password                = random_password.password[0].result
  instance_class          = var.db_instance["instance_class"]
  storage_type            = var.db_instance["storage_type"]
  allocated_storage       = var.db_instance["allocated_storage"]
  max_allocated_storage   = var.db_instance["max_allocated_storage"]
  vpc_security_group_ids  = [aws_security_group.rds_sg[0].id]
  publicly_accessible     = var.db_instance["publicly_accessible"]
  db_name                 = var.db_instance["db_name"]
  backup_retention_period = var.db_instance["backup_retention_period"]
  deletion_protection     = var.db_instance["deletion_protection"]
  skip_final_snapshot     = var.db_instance["skip_final_snapshot"]
}


### All the resources related to RDS Cluster such as Aurora-MySQL have been defined below

data "aws_rds_engine_version" "terraform_rds_cluster_engine" {
  engine             = var.rds_cluster["engine_name"]
  preferred_versions = var.rds_cluster["preferred_versions"]
}

data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_rds_cluster" "terraform_rds_cluster" {
  count                   = local.create_rds_cluster ? 1 : 0
  engine                  = data.aws_rds_engine_version.terraform_rds_cluster_engine.engine
  engine_version          = data.aws_rds_engine_version.terraform_rds_cluster_engine.version
  cluster_identifier      = var.rds_cluster["cluster_identifier"]
  availability_zones      = data.aws_availability_zones.available_zones.names
  database_name           = var.rds_cluster["database_name"]
  master_username         = var.rds_cluster["master_username"]
  master_password         = random_password.password[0].result
  vpc_security_group_ids  = [aws_security_group.rds_sg[0].id]
  backup_retention_period = var.rds_cluster["backup_retention_period"]
  deletion_protection     = var.rds_cluster["deletion_protection"]
  skip_final_snapshot     = var.rds_cluster["skip_final_snapshot"]
}

resource "aws_rds_cluster_instance" "terraform_rds_cluster_instace" {
  count              = local.create_rds_cluster && local.create_rds_cluster_instance ? length(var.rds_instances) : 0
  identifier         = "terraform-aurora-cluster-${count.index}"
  cluster_identifier = aws_rds_cluster.terraform_rds_cluster[0].id
  instance_class     = var.rds_instances[count.index]["instance_type"]
  engine             = aws_rds_cluster.terraform_rds_cluster[0].engine
  engine_version     = aws_rds_cluster.terraform_rds_cluster[0].engine_version
}