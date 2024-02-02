variable "create_instace" {
  type    = bool
  default = true
}

variable "create_security_group" {
  type    = bool
  default = true
}

variable "create_placement_group" {
  type    = bool
  default = true
}

variable "create_network_interface" {
  type    = bool
  default = true
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "subnet_id" {
  type    = string
  default = "subnet-020b19c7eaf6972ee"
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
    ssh_rule = {
      description = "SSH Ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    http_rule = {
      description = "HTTP Ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
