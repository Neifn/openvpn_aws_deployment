resource "aws_security_group" "custom_security" {
  name        = "${var.cluster_name}_sg"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name = "${var.cluster_name}_sg"
  }
}

resource "aws_security_group_rule" "custom_rule" {
  type            = "ingress"
  from_port       = "22"
  to_port         = "2"
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.custom_security.id}"
}
resource "aws_security_group_rule" "allow_all" {
  type            = "egress"
  from_port       = 0
  to_port         = 65535
  protocol        = "all"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.custom_security.id}"
}
