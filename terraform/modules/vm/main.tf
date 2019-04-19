resource "aws_eip" "pip" {
  vpc              = true
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.cluster_name}-openvpn-key-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }
}

data "template_file" "userdata" {
  template = "#!/bin/bash\n${file("../../user_data/configure_vpn.tpl")}"
  vars {
    ALLOCATION_ID             = "${aws_eip.pip.id}"
    PUBLIC_IP                 = "${aws_eip.pip.public_ip}" 
  }
}

resource "tls_private_key" "vpn_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create aws key pair for openvpn vm
resource "aws_key_pair" "vpn_machine_key" {
  key_name   = "${var.cluster_name}-ssh-key"
  public_key = "${tls_private_key.vpn_key.public_key_openssh}"
}

resource "aws_launch_configuration" "lc_conf_vpn" {
  name_prefix                 = "${var.cluster_name}_lc_prod_"
  image_id                    = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.vpn_machine_key.key_name}"
  associate_public_ip_address = "${var.public_ip}"
  security_groups             = ["${var.vpc_security_group_id}"]
  iam_instance_profile        = "${var.instance_profile}"
  user_data                   = "${data.template_file.userdata.rendered}"
  spot_price                  = "0.003"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_prod" {
  name                      = "${aws_launch_configuration.lc_conf_vpn.name}"
  launch_configuration      = "${aws_launch_configuration.lc_conf_vpn.name}"
  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  vpc_zone_identifier       = ["${var.subnet_ids}"]

  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.cluster_name}_vpn"
      propagate_at_launch = true
    }
  ]
}