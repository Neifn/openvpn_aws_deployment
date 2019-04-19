output "sg_id" {
  value = "${aws_security_group.custom_security.id}"
}

output "sg_arn" {
  value = "${aws_security_group.custom_security.arn}"
}

output "sg_name" {
  value = "${aws_security_group.custom_security.name}"
}