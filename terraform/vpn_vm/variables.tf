variable "region" {
  default = "us-east-2"
}

variable "ami_id" {}

variable "cluster_name" {
  default = "spotvpn"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}