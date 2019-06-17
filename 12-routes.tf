resource "azurerm_route_table" "route_main" {
  name                                      = "${var.vm_name}-${var.environment}-udr"
  location                                  = "${data.azurerm_resource_group.rg.location}"
  resource_group_name                       = "${data.azurerm_resource_group.rg.name}"
  disable_bgp_route_propagation             = false
  tags                                      = "${var.tags}"


  route {
    name                                    = "to_hub_fw"
    address_prefix                          = "0.0.0.0/0"
    next_hop_type                           = "VirtualAppliance"
    next_hop_in_ip_address                  = "10.99.132.5" # Needs to be fixed to be dynamic
  }
}

resource "azurerm_subnet_route_table_association" "route_association" {
  subnet_id      = "${var.selfip_subnet}"
  route_table_id = "${azurerm_route_table.route_main.id}"
}

