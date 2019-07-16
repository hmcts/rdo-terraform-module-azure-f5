locals {
  default_gateway                                   = "${cidrhost(data.azurerm_subnet.subnet.address_prefix,1)}"
}

#data "azurerm_subnet" "subnet" {
#  name                                      = "dmz-loadbalancer"
#  virtual_network_name                      = "${data.azurerm_virtual_network.vnet.name}"
#  resource_group_name                       = "${data.azurerm_resource_group.rg.name}"
#}

#data "azurerm_resource_group" "hub" {
#  name                                      = "hub-firewall"
#}

#data "azurerm_network_interface" "palo_ip" {
#  name                                      = "fw-sbox-nic-transit-public-0"
#  resource_group_name                       = "${data.azurerm_resource_group.hub.name}"
#}

#locals {
#  palo_ip                                   = "${data.azurerm_network_interface.palo_ip.private_ip_address}"
#}