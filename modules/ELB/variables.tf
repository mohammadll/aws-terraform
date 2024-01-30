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
