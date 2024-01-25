variable "create_efs_file_system" {
  type    = bool
  default = true
}

variable "create_efs_mount_target" {
  type    = bool
  default = true
}

variable "create_efs_backup_policy" {
  type    = bool
  default = true
}

variable "efs" {
  type = object({
    creation_token   = string
    encrypted        = bool
    performance_mode = string
    throughput_mode  = string
    backup_policy    = string
  })
  default = {
    creation_token   = "terraform"
    encrypted        = true
    performance_mode = "generalPurpose"
    throughput_mode  = "elastic"
    backup_policy    = "ENABLED"
  }
}

variable "security_group" {
  type = object({
    sg_ingress_from_port   = number
    sg_ingress_to_port     = number
    sg_ingress_protocol    = string
    sg_ingress_cidr_blocks = list(string)
    sg_egress_from_port    = number
    sg_egress_to_port      = number
    sg_egress_protocol     = string
    sg_egress_cidr_blocks  = list(string)
  })
  default = {
    sg_ingress_from_port   = 2049
    sg_ingress_to_port     = 2049
    sg_ingress_protocol    = "tcp"
    sg_ingress_cidr_blocks = ["0.0.0.0/0"]
    sg_egress_from_port    = 0
    sg_egress_to_port      = 0
    sg_egress_protocol     = "-1"
    sg_egress_cidr_blocks  = ["0.0.0.0/0"]
  }
}
