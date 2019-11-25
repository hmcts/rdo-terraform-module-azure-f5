resource "azurerm_subnet" "f5_data_subnet" {
  name                        = "${var.env_name}-data"
  resource_group_name         = "${azurerm_resource_group.f5-rg.name}"
  virtual_network_name        = "${azurerm_virtual_network.f5_vnet.name}"
  address_prefix              = "${var.loadbalancer_data_subnet_prefix}"
  lifecycle { 
     ignore_changes                 = ["route_table_id"]
  }
}

resource "azurerm_subnet" "f5_mgmt_subnet" {
  name                        = "${var.env_name}-mgmt"
  resource_group_name         = "${azurerm_resource_group.f5-rg.name}"
  virtual_network_name        = "${azurerm_virtual_network.f5_vnet.name}"
  address_prefix              = "${var.loadbalancer_mgmt_subnet_prefix}"
  network_security_group_id   = "${azurerm_network_security_group.f5_mgmt_nsg.id}"
}
