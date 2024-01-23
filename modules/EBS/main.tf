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

resource "aws_instance" "terraform" {
  ami           = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type

  tags = {
    Name       = "terraform-instance"
    created_by = "mohammad"
  }
}

data "aws_instance" "terraform" {
  instance_id = aws_instance.terraform.id

  filter {
    name   = "tag:Name"
    values = ["terraform-instance"]
  }
}

resource "aws_ebs_volume" "terraform-volume" {
  availability_zone = data.aws_instance.terraform.availability_zone
  size              = var.ebs_volume["size"]
  type              = var.ebs_volume["type"]
  iops              = var.ebs_volume["iops"]
  throughput        = var.ebs_volume["throughput"]

  tags = {
    Name = "terraform-volume"
  }
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name = var.ebs_attachment_device_name
  volume_id   = aws_ebs_volume.terraform-volume.id
  instance_id = aws_instance.terraform.id
}

resource "aws_ebs_snapshot" "ebs_snapshot" {
  volume_id = aws_ebs_volume.terraform-volume.id

  tags = {
    Name = "terraform_volume_snap"
  }
}
