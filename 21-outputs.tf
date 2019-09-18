output "lb_public_ip" {
  value = "${azurerm_public_ip.pip_lb.ip_address}"
}

output "f5_vnet_id" {
  value = "${azurerm_virtual_network.f5_vnet.id}"
}

output "f5_vnet_name" {
  value = "${azurerm_virtual_network.f5_vnet.name}"
}
