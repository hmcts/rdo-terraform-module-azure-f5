locals {
  default_gateway                                   = "${cidrhost(data.azurerm_subnet.subnet.address_prefix,1)}"
}

#data "azurerm_subnet" "subnet" {
#  name                                      = "dmz-loadbalancer"
#  virtual_network_name                      = "${data.azurerm_virtual_network.vnet.name}"
#  resource_group_name                       = "${data.azurerm_resource_group.rg.name}"
#}


data "azurerm_resource_group" "ctsc-email-pan" {
  #id = "${var.pan_resource_group}"
  name                                      = "ctsc-email-pan-${var.environment}"
}

data "azurerm_lb" "palo_lb_ip" {
  name                                      = "ctsc-email-pan-ilb"
  resource_group_name                       = "${data.azurerm_resource_group.ctsc-email-pan.name}"
}

locals {
  palo_lb_ip                                   = "${data.azurerm_lb.palo_lb_ip.private_ip_address}"
}
