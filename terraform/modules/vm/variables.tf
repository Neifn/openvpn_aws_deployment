variable "cluster_name" {
  default = "spotvpn"
}

variable "instance_type" {
  default = "t3.nano"
}

variable "subnet_ids" {
  default = ""
}

variable "public_ip" {
  default = false
}

variable "vpc_security_group_id" {
  default = ""
}

variable "min_size" {
  default = "1"
}

variable "max_size" {
  default = "1"
}

variable "ami_id" {}

variable "instance_profile" {}