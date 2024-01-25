variable "create_instance" {
  type    = bool
  default = true
}

variable "create_ami_from_instance" {
  type    = bool
  default = true
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
