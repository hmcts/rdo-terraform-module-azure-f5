output "lb_public_ip" {
  value = "${azurerm_public_ip.pip_lb.ip_address}"
}

output "f5_vnet_id" {
  value = "${azurerm_virtual_network.f5_vnet.id}"
}

output "f5_vnet_name" {
  value = "${azurerm_virtual_network.f5_vnet.name}"
}

output "f5_rg_name" {
  value = "${azurerm_resource_group.f5-rg.name}"
}

output "loadbalancer_address_space" {
  value = "${azurerm_virtual_network.f5_vnet.address_space}"
}
