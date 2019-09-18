resource "azurerm_virtual_network" "f5_vnet" {
  name                                    = "${var.loadbalancer_vnet}"
  resource_group_name                     = "${data.azurerm_resource_group.rg.name}"
  address_space                           = ["${var.loadbalancer_address_space}"]
  location                                = "${data.azurerm_resource_group.rg.location}"
}
