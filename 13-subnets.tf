data "azurerm_subnet" "subnet" {
  name                                    = "${var.loadbalancer_data_subnet}"
  resource_group_name                     = "${data.azurerm_resource_group.rg.name}"
  virtual_network_name                    = "${data.azurerm_virtual_network.vnet.name}"
}
