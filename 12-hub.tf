
data "azurerm_resource_group" "hub" {
  name                                      = "hub-firewall"
}

data "azurerm_network_interface" "palo_ip" {
  name                                      = "nic-dmz-firewall-transit-0"
  resource_group_name                       = "${data.azurerm_resource_group.hub.name}"
}

locals {
  palo_ip                                   = "${data.azurerm_network_interface.palo_ip.private_ip_address}"
}