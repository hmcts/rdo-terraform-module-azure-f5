locals {
  f5_nsg_key = "${split(";", var.nsg_key)}"
}

resource "azurerm_network_security_group" "f5_mgmt_nsg" {
  name                = "${var.env_name}-nsg-mgmt"
  resource_group_name = "${azurerm_resource_group.f5-rg.name}"
  location            = "${var.location}"
}

resource "azurerm_network_security_rule" "f5_mgmt_nsg" {
  count                       = "${length(local.f5_nsg_key)}"
  name                        = "${element(split(":", element(local.f5_nsg_key, count.index)), 1)}"
  priority                    = "${element(split(":", element(local.f5_nsg_key, count.index)), 2)}"
  direction                   = "${element(split(":", element(local.f5_nsg_key, count.index)), 3)}"
  access                      = "${element(split(":", element(local.f5_nsg_key, count.index)), 4)}"
  protocol                    = "${element(split(":", element(local.f5_nsg_key, count.index)), 5)}"
  source_port_range           = "${element(split(":", element(local.f5_nsg_key, count.index)), 6)}"
  destination_port_range      = "${element(split(":", element(local.f5_nsg_key, count.index)), 7)}"
  source_address_prefix       = "${element(split(":", element(local.f5_nsg_key, count.index)), 8)}"
  destination_address_prefix  = "${element(split(":", element(local.f5_nsg_key, count.index)), 9)}"
  resource_group_name         = "${azurerm_resource_group.f5-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.f5_mgmt_nsg.name}"
}
