output "vpn_private_key_pem" {
  value = "${module.openvpn_vm.vpn_private_key_pem}"
}

output "open_vpn_public_ip" {
  value = "${module.openvpn_vm.open_vpn_public_ip}"
}