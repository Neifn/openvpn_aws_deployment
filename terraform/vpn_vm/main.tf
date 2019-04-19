terraform {
  backend "s3" {
    key    = "terraform/openvpn.tfstate"
  }
}

provider "aws" {
  region = "${var.region}"
}

module "network" {
  source         = "../modules/vpc"
  cluster_name   = "${var.cluster_name}"
}

module "security" {
  source         = "../modules/sg"
  vpc_id         = "${module.network.vpc_id}"
  cluster_name   = "${var.cluster_name}"
  vpc_cidr_block = "${var.vpc_cidr_block}"
}

module "iam" {
  source         = "../modules/iam"
  cluster_name   = "${var.cluster_name}"
}

module "openvpn_vm" {
  source                = "../modules/vm"
  cluster_name          = "${var.cluster_name}"
  subnet_ids            = "${module.network.public_subnet_ids}"
  vpc_security_group_id = "${module.security.sg_id}"
  ami_id                = "${var.ami_id}"
  instance_profile      = "${module.iam.instance_profile}"
}
