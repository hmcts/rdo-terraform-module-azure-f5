
data "azurerm_resource_group" "hub" {
  name                                      = "hub-firewall"
}

data "azurerm_network_interface" "test" {
  name                                      = "nic-dmz-firewall-transit-0"
  resource_group_name                       = "${data.azurerm_resource_group.hub.name}"
}