variable "create_security_group" {
  type    = bool
  default = true
}

variable "create_load_balancer" {
  type    = bool
  default = true
}

variable "create_target_group" {
  type    = bool
  default = true
}

variable "create_listener_rule" {
  type    = bool
  default = true
}

variable "create_launch_configuration" {
  type = bool
  default = true
}

variable "create_autoscaling_group" {
  type = bool
  default = true
}

variable "create_autoscaling_attachment" {
  type = bool
  default = true
}

variable "create_autoscaling_policy" {
  type = bool
  default = true
}

variable "load_balancer" {
  type = object({
    name   = string
    scheme = bool
    type   = string
  })
  default = {
    name   = "terraform-load-balancer"
    scheme = false
    type   = "application"
  }
}

variable "security_ingress_rules" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    http_rule = {
      description = "Allow Traffic from HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "cross_zone_load_balancing" {
  type    = bool
  default = true
}

variable "target_group" {
  type = object({
    name             = string
    port             = number
    type             = string
    protocol         = string
    protocol_version = string
  })
  default = {
    name             = "terraform-target-group"
    port             = 80
    type             = "instance"
    protocol         = "HTTP"
    protocol_version = "HTTP1"
  }
}

variable "stickiness" {
  type = object({
    type            = string
    enabled         = bool
    cookie_name     = string
    cookie_duration = number
  })
  default = {
    type            = "lb_cookie"
    enabled         = true
    cookie_name     = "AWSTERRAFORM"
    cookie_duration = 3600
  }
}

variable "load_balancer_listener" {
  type = map(string)
  default = {
    port     = "80"
    protocol = "HTTP"

  }
}

variable "rule_priority" {
  type    = number
  default = 5
}

variable "lc_instance_type" {
  type = string
  default = "t2.micro"
}

variable "lc_name_prefix" {
  type = string
  default = "terraform-lc-"
}

variable "autoscaling_group" {
  type = object({
    name = string
    max_size = number
    min_size = number
    cooldown = number
    health_check_grace_period = number
    health_check_type = string
    desired_capacity = number
    force_delete = bool
  })
  default = {
    name = "terraform_autoscaling_group"
    max_size = 1
    min_size = 1
    cooldown = 400
    health_check_grace_period = 400
    health_check_type = "ELB"
    desired_capacity = 1
    force_delete = true
  }
}

variable "autoscaling_policy" {
  type = object({
    autoscaling_policy_name = string
    policy_type = string
    predefined_metric_type = string
    target_value = number
  })
  default = {
    autoscaling_policy_name = "terraform_autoscaling_policy"
    policy_type = "TargetTrackingScaling"
    predefined_metric_type = "ASGAverageCPUUtilization"
    target_value = 40.0
  }
}