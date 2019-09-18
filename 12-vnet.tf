resource "azurerm_virtual_network" "f5_vnet" {
  name                                    = "${var.loadbalancer_vnet_name}"
  resource_group_name                     = "${azurerm_resource_group.f5-rg.name}"
  address_space                           = ["${var.loadbalancer_address_space}"]
  location                                = "${azurerm_resource_group.f5-rg.location}"
}
