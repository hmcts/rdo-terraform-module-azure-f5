resource "azurerm_virtual_network" "f5-vnet" {
  name                                    = "${var.loadbalancer_vnet}"
  resource_group_name                     = "${data.azurerm_resource_group.rg.name}"
  address_space                           = ["${data.azurerm_key_vault_secret.f5_vnet_cidr.value.}"]
  location                                = "${var.location}"
}
