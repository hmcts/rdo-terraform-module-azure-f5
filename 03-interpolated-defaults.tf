locals {
  default_gateway                                   = "${cidrhost(data.azurerm_subnet.subnet.address_prefix,1)}"
}

data "azurerm_virtual_network" "vnet" {
  name                                      = "${data.azurerm_resource_group.rg.name}-${var.environment}"
  resource_group_name                       = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_subnet" "subnet" {
  name                                      = "dmz-loadbalancer"
  virtual_network_name                      = "${data.azurerm_virtual_network.vnet.name}"
  resource_group_name                       = "${data.azurerm_resource_group.rg.name}"
}

