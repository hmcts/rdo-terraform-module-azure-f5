resource "azurerm_route_table" "route_main" {
  name                                      = "${var.vm_name}-${var.environment}-udr"
  location                                  = "${data.azurerm_resource_group.rg.location}"
  resource_group_name                       = "${data.azurerm_resource_group.rg.name}"
  disable_bgp_route_propagation             = false
  tags                                      = "${var.tags}"


  route {
    name                                    = "internet_out"
    address_prefix                          = "0.0.0.0/0"
    next_hop_type                           = "Internet"
  }

}
