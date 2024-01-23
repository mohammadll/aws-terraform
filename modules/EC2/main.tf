data "aws_ami" "amazon-linux" {
  most_recent      = true
  owners           = ["amazon"]

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

resource "aws_key_pair" "ec2" {
  key_name   = "ec2-instance"
  public_key = file("${path.module}/terraform.pub")
}

resource "aws_security_group" "web-server-rules" {
  name = "web_server_rules"

  dynamic "ingress" {
    for_each = var.security_ingress_rules
    content {
      description = ingress.value["description"]
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

resource "aws_placement_group" "partition" {
  name            = "distributed_group"
  strategy        = "partition"
  partition_count = 4
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = var.ec2_instance_role
}

resource "aws_instance" "terraform" {
  ami                    = data.aws_ami.amazon-linux.id
  instance_type          = var.instance_type
  placement_group        = aws_placement_group.partition.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  key_name               = aws_key_pair.ec2.key_name
  vpc_security_group_ids = [aws_security_group.web-server-rules.id]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/terraform")
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo yum -y install httpd",
      "sudo systemctl enable --now httpd",
      "sudo chown -R ec2-user:ec2-user /var/www/html/",
      "sudo echo '<h1>hello from terraform</h1>' > /var/www/html/index.html"
    ]
  }
  tags = {
    Name       = "terraform-instance"
    created_by = "mohammad"
  }
}

resource "aws_network_interface" "secondary_ip_address" {
  description     = "Secondary IP Address"
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.web-server-rules.id]
}

resource "aws_network_interface_attachment" "secondary_ip_address_attachment" {
  instance_id          = aws_instance.terraform.id
  network_interface_id = aws_network_interface.secondary_ip_address.id
  device_index         = 1
}
