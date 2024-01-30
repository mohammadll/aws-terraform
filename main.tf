# Change 'true' to 'false' if you DO NOT want those resources to be created; all of them are set to 'true' by default


provider "aws" {
  region = "us-east-2"
}

module "iam_resources" {
  source                                                    = "./modules/IAM"
  create_iam_group                                          = true
  create_iam_read_only_and_s3_full_access_policy            = true
  create_iam_read_only_and_s3_full_access_policy_attachment = true
  create_iam_users                                          = true
  create_iam_ec2_get_console_screenshot_policy              = true
  create_iam_ec2_get_console_screenshot_policy_attachment   = true
  create_iam_user_group_membership                          = true
  create_iam_role_with_policy                               = true
}

module "instance_resources" {
  source                   = "./modules/EC2"
  create_instace           = true
  create_security_group    = true
  create_placement_group   = true
  create_network_interface = true
}

module "ebs_resources" {
  source                             = "./modules/EBS"
  create_instance                    = true
  create_instance_volume             = true
  create_instance_volume_attachement = true
  create_instance_volume_snapshot    = true
}

module "create_ami_from_instance" {
  source                   = "./modules/AMI"
  create_instance          = true
  create_ami_from_instance = true
}

module "efs_resources" {
  source                   = "./modules/EFS"
  create_efs_file_system   = true
  create_efs_mount_target  = true
  create_efs_backup_policy = true
}

module "elb_resources" {
  source                = "./modules/ELB"
  create_security_group = true
  create_load_balancer  = true
  create_target_group   = true
  create_listener_rule  = true
}
