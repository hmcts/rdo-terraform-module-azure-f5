resource "azurerm_route_table" "route_main" {
  name                                      = "${var.vm_name}-udr"
  location                                  = "${data.azurerm_resource_group.rg.location}"
  resource_group_name                       = "${data.azurerm_resource_group.rg.name}"
  disable_bgp_route_propagation             = false

  route {
    name                                    = "internet_out"
    address_prefix                          = "0.0.0.0/0"
    next_hop_type                           = "Internet"
  }

  route {
    name                                    = "inbound_trust"
    address_prefix                          = "${var.lb_subnet_vip}"
    next_hop_type                           = "VirtualAppliance"
    next_hop_in_ip_address                  = "${var.selfip_private_ip}"
  }

}
