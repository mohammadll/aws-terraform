locals {
  create_security_group         = var.create_security_group
  create_load_balancer          = var.create_load_balancer
  create_target_group           = var.create_target_group
  create_listener_rule          = var.create_listener_rule
  create_launch_configuration   = var.create_launch_configuration
  create_autoscaling_group      = var.create_autoscaling_group
  create_autoscaling_attachment = var.create_autoscaling_attachment
  create_autoscaling_policy     = var.create_autoscaling_policy
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

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "subnets_ids" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

resource "aws_security_group" "elb_sg" {
  count       = local.create_security_group ? 1 : 0
  name        = "terraform-security-group"
  description = "Security group for elastic load balancer"

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

resource "aws_lb_target_group" "target_group" {
  count            = local.create_target_group ? 1 : 0
  name             = var.target_group["name"]
  port             = var.target_group["port"]
  target_type      = var.target_group["type"]
  protocol         = var.target_group["protocol"]
  protocol_version = var.target_group["protocol_version"]
  vpc_id           = data.aws_vpc.default_vpc.id
  stickiness {
    type            = var.stickiness["type"]
    enabled         = var.stickiness["enabled"]
    cookie_name     = var.stickiness["type"] == "app_cookie" ? var.stickiness["cookie_name"] : null
    cookie_duration = var.stickiness["type"] == "lb_cookie" ? var.stickiness["cookie_duration"] : null
  }
}

resource "aws_lb" "load_balancer" {
  count              = local.create_load_balancer ? 1 : 0
  name               = var.load_balancer["name"]
  internal           = var.load_balancer["scheme"]
  load_balancer_type = var.load_balancer["type"]
  security_groups    = local.create_security_group ? [aws_security_group.elb_sg[0].id] : null
  subnets            = [for subnet_id in data.aws_subnets.subnets_ids.ids : subnet_id]

  enable_deletion_protection       = var.deletion_protection
  enable_cross_zone_load_balancing = var.cross_zone_load_balancing

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "load_balancer_listener" {
  count             = local.create_load_balancer && local.create_target_group ? 1 : 0
  load_balancer_arn = aws_lb.load_balancer[0].arn
  port              = var.load_balancer_listener["port"]
  protocol          = var.load_balancer_listener["protocol"]
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[0].arn
  }
}

resource "aws_lb_listener_rule" "listener_rule" {
  count        = local.create_load_balancer && local.create_target_group && local.create_listener_rule ? 1 : 0
  listener_arn = aws_lb_listener.load_balancer_listener[0].arn
  priority     = var.rule_priority

  action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Custom Error, Page Not Found !!!!!"
      status_code  = "404"
    }
    target_group_arn = aws_lb_target_group.target_group[0].arn
  }

  condition {
    path_pattern {
      values = ["/error"]
    }
  }
}


resource "aws_key_pair" "ec2" {
  count      = local.create_launch_configuration ? 1 : 0
  key_name   = "ec2-instance"
  public_key = file("${path.module}/terraform.pub")
}

resource "aws_launch_configuration" "template" {
  count           = local.create_launch_configuration ? 1 : 0
  name_prefix     = var.lc_name_prefix
  image_id        = data.aws_ami.amazon-linux.id
  instance_type   = var.lc_instance_type
  key_name        = aws_key_pair.ec2[0].key_name
  security_groups = local.create_security_group ? [aws_security_group.elb_sg[0].id] : null
  user_data       = file("${path.module}/install_httpd.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  count                     = local.create_launch_configuration && local.create_autoscaling_group ? 1 : 0
  name                      = var.autoscaling_group["name"]
  max_size                  = var.autoscaling_group["max_size"]
  min_size                  = var.autoscaling_group["min_size"]
  default_cooldown          = var.autoscaling_group["cooldown"]
  health_check_grace_period = var.autoscaling_group["health_check_grace_period"]
  health_check_type         = var.autoscaling_group["health_check_type"]
  desired_capacity          = var.autoscaling_group["desired_capacity"]
  force_delete              = var.autoscaling_group["force_delete"]
  launch_configuration      = aws_launch_configuration.template[0].name
  vpc_zone_identifier       = [for subnet_id in data.aws_subnets.subnets_ids.ids : subnet_id]
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "autoscaling_attachment" {
  count                  = local.create_target_group && local.create_autoscaling_group && local.create_autoscaling_attachment ? 1 : 0
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group[0].id
  lb_target_group_arn    = aws_lb_target_group.target_group[0].arn
}

resource "aws_autoscaling_policy" "autoscaling_policy" {
  count                  = local.create_autoscaling_group && local.create_autoscaling_policy ? 1 : 0
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group[0].id
  name                   = var.autoscaling_policy["autoscaling_policy_name"]
  policy_type            = var.autoscaling_policy["policy_type"]
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.autoscaling_policy["predefined_metric_type"]
    }
    target_value = var.autoscaling_policy["target_value"]
  }
}