locals {
  create_instace           = var.create_instace
  create_security_group    = var.create_security_group
  create_placement_group   = var.create_placement_group
  create_network_interface = var.create_network_interface
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

resource "aws_key_pair" "ec2" {
  count      = local.create_instace ? 1 : 0
  key_name   = "ec2-instance"
  public_key = file("${path.module}/terraform.pub")
}

resource "aws_security_group" "web-server-rules" {
  count = local.create_security_group ? 1 : 0
  name  = "web_server_rules"

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
  count           = local.create_placement_group ? 1 : 0
  name            = "distributed_group"
  strategy        = "partition"
  partition_count = 4
}

resource "aws_instance" "terraform" {
  count                  = local.create_instace ? 1 : 0
  ami                    = data.aws_ami.amazon-linux.id
  instance_type          = var.instance_type
  placement_group        = local.create_placement_group ? aws_placement_group.partition[0].id : null
  key_name               = aws_key_pair.ec2[0].key_name
  vpc_security_group_ids = local.create_security_group ? [aws_security_group.web-server-rules[0].id] : null
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
  count           = local.create_network_interface ? 1 : 0
  description     = "Secondary IP Address"
  subnet_id       = var.subnet_id
  security_groups = local.create_security_group ? [aws_security_group.web-server-rules[0].id] : null
}

resource "aws_network_interface_attachment" "secondary_ip_address_attachment" {
  count                = local.create_instace && local.create_network_interface ? 1 : 0
  instance_id          = aws_instance.terraform[0].id
  network_interface_id = aws_network_interface.secondary_ip_address[0].id
  device_index         = 1
}
