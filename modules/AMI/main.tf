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

resource "aws_ami_from_instance" "my_own_ami" {
  name               = "my-own-ami"
  source_instance_id = aws_instance.terraform.id
}

data "aws_ami" "my_own_ami" {
  most_recent = true
  owners      = ["self"]

  depends_on = [
    aws_instance.terraform
  ]

  filter {
    name   = "name"
    values = ["*own*"]
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
