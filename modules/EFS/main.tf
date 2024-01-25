locals {
  create_efs_file_system   = var.create_efs_file_system
  create_efs_mount_target  = var.create_efs_mount_target
  create_efs_backup_policy = var.create_efs_backup_policy
  default_efs_lifecycle_policies = {
    transition_to_ia                    = "AFTER_14_DAYS",
    transition_to_primary_storage_class = "AFTER_1_ACCESS",
  }
}

data "aws_availability_zones" "available_zones" {
  state = "available"
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "subnets_ids" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

resource "aws_security_group" "efs_mount_target_sg" {
  count       = local.create_efs_file_system && local.create_efs_mount_target ? 1 : 0
  name        = "efs_mount_target_sg"
  description = "Security group for EFS mount targets"

  vpc_id = data.aws_vpc.default_vpc.id

  ingress {
    from_port   = var.security_group["sg_ingress_from_port"]
    to_port     = var.security_group["sg_ingress_to_port"]
    protocol    = var.security_group["sg_ingress_protocol"]
    cidr_blocks = var.security_group["sg_ingress_cidr_blocks"]
  }

  egress {
    from_port   = var.security_group["sg_egress_from_port"]
    to_port     = var.security_group["sg_egress_to_port"]
    protocol    = var.security_group["sg_egress_protocol"]
    cidr_blocks = var.security_group["sg_egress_cidr_blocks"]
  }
}

resource "aws_efs_file_system" "efs" {
  count            = local.create_efs_file_system ? 1 : 0
  creation_token   = var.efs["creation_token"]
  encrypted        = var.efs["encrypted"]
  performance_mode = var.efs["performance_mode"]
  throughput_mode  = var.efs["throughput_mode"]
  lifecycle_policy {
    transition_to_ia = lookup(local.default_efs_lifecycle_policies, "transition_to_ia", null)
  }

  lifecycle_policy {
    transition_to_primary_storage_class = lookup(local.default_efs_lifecycle_policies, "transition_to_primary_storage_class", null)
  }

  tags = {
    Name = "terraform-efs"
  }
}

resource "aws_efs_mount_target" "efs_mount_target" {
  count           = local.create_efs_file_system && local.create_efs_mount_target ? length(data.aws_availability_zones.available_zones.names) : 0
  file_system_id  = aws_efs_file_system.efs[0].id
  subnet_id       = data.aws_subnets.subnets_ids.ids[count.index]
  security_groups = [aws_security_group.efs_mount_target_sg[0].id]
}

resource "aws_efs_backup_policy" "policy" {
  count          = local.create_efs_file_system && local.create_efs_backup_policy ? 1 : 0
  file_system_id = aws_efs_file_system.efs[0].id

  backup_policy {
    status = var.efs["backup_policy"]
  }
}
