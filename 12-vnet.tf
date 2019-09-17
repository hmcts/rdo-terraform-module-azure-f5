data "azurerm_virtual_network" "vnet" {
  name                = var.loadbalancer_vnet
  resource_group_name = data.azurerm_resource_group.rg.name
}

