provider "aws" {
  region = "us-east-2"
}

module "iam_resources" {
  source = "./modules/IAM"
}

module "instance_resources" {
  source            = "./modules/EC2"
  ec2_instance_role = module.iam_resources.ec2_instance_role
}
