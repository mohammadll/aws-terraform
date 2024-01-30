provider "aws" {
  region = "us-east-2"
}

module "iam_resources" {
  source = "./modules/IAM"
}

module "instance_resources" {
  source                   = "./modules/EC2"
  create_instace           = true # this variable is true by default. If you don't want it to be created, change it to false
  create_security_group    = true # this variable is true by default. If you don't want it to be created, change it to false
  create_placement_group   = true # this variable is true by default. If you don't want it to be created, change it to false
  create_network_interface = true # this variable is true by default. If you don't want it to be created, change it to false
}

module "ebs_resources" {
  source                             = "./modules/EBS"
  create_instance                    = true # this variable is true by default. If you don't want it to be created, change it to false
  create_instance_volume             = true # this variable is true by default. If you don't want it to be created, change it to false
  create_instance_volume_attachement = true # this variable is true by default. If you don't want it to be created, change it to false
  create_instance_volume_snapshot    = true # this variable is true by default. If you don't want it to be created, change it to false
}

module "create_ami_from_instance" {
  source                   = "./modules/AMI"
  create_instance          = true # this variable is true by default. If you don't want it to be created, change it to false
  create_ami_from_instance = true # this variable is true by default. If you don't want it to be created, change it to false
}

module "efs_resources" {
  source                   = "./modules/EFS"
  create_efs_file_system   = true # this variable is true by default. If you don't want it to be created, change it to false
  create_efs_mount_target  = true # this variable is true by default. If you don't want it to be created, change it to false
  create_efs_backup_policy = true # this variable is true by default. If you don't want it to be created, change it to false
}

module "elb_resources" {
  source                = "./modules/ELB"
  create_security_group = true # this variable is true by default. If you don't want it to be created, change it to false
  create_load_balancer  = true # this variable is true by default. If you don't want it to be created, change it to false
  create_target_group   = true # this variable is true by default. If you don't want it to be created, change it to false
  create_listener_rule  = true # this variable is true by default. If you don't want it to be created, change it to false
}
