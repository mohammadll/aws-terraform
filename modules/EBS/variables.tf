variable "create_instance" {
  type    = bool
  default = true
}

variable "create_instance_volume" {
  type    = bool
  default = true
}

variable "create_instance_volume_attachement" {
  type    = bool
  default = true
}

variable "create_instance_volume_snapshot" {
  type    = bool
  default = true
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ebs_volume" {
  type = object({
    size       = number
    type       = string
    iops       = number
    throughput = number
  })
  default = {
    type       = "gp3"
    size       = 2
    iops       = 3000
    throughput = 125
  }
}

variable "ebs_attachment_device_name" {
  type    = string
  default = "/dev/sdf"
}
