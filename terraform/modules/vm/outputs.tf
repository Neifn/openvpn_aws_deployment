output "vpn_private_key_pem" {
  value = "${aws_key_pair.vpn_key.private_key_pem}"
}

output "open_vpn_public_ip" {
  value = "${aws_eip.pip.public_ip}"
}