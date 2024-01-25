locals {
  create_instance                    = var.create_instance
  create_instance_volume             = var.create_instance_volume
  create_instance_volume_attachement = var.create_instance_volume_attachement
  create_instance_volume_snapshot    = var.create_instance_volume_snapshot
}

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*kernel-6.1-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "terraform-instance" {
  count         = local.create_instance ? 1 : 0
  ami           = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type

  tags = {
    Name       = "terraform-instance"
    created_by = "mohammad"
  }
}

data "aws_instance" "terraform-instance" {
  count       = local.create_instance ? 1 : 0
  instance_id = aws_instance.terraform-instance[0].id

  filter {
    name   = "tag:Name"
    values = ["terraform-instance"]
  }
}

resource "aws_ebs_volume" "terraform-instance-volume" {
  count             = local.create_instance && local.create_instance_volume ? 1 : 0
  availability_zone = data.aws_instance.terraform-instance[0].availability_zone
  size              = var.ebs_volume["size"]
  type              = var.ebs_volume["type"]
  iops              = var.ebs_volume["iops"]
  throughput        = var.ebs_volume["throughput"]

  tags = {
    Name = "terraform-instance-volume"
  }
}

resource "aws_volume_attachment" "terraform-instance-volume-attachment" {
  count       = local.create_instance && local.create_instance_volume && local.create_instance_volume_attachement ? 1 : 0
  device_name = var.ebs_attachment_device_name
  volume_id   = aws_ebs_volume.terraform-instance-volume[0].id
  instance_id = aws_instance.terraform-instance[0].id
}

resource "aws_ebs_snapshot" "terraform-instance-volume-snapshot" {
  count     = local.create_instance && local.create_instance_volume && local.create_instance_volume_snapshot ? 1 : 0
  volume_id = aws_ebs_volume.terraform-instance-volume[0].id

  tags = {
    Name = "terraform-instance-volume-snap"
  }
}
