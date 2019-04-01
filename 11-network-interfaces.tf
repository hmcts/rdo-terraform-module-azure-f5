resource "azurerm_network_interface" "nic_mgmt" {
  name                = "${var.vm_name}-nic01"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "${var.vm_name}-nic02-ip01"
    subnet_id                     = "${var.subnet_mgmt_id}"
    private_ip_address_allocation = "dynamic"
  }
}

#resource "azurerm_network_interface" "nic_vip" {
#  name                = "${var.vm_name}-nic02"
#  location            = "${data.azurerm_resource_group.rg.location}"
#  resource_group_name = "${data.azurerm_resource_group.rg.name}"
##  ip_configuration    = "${var.vip_ip_configuration}"
#  ip_configuration    = "${element(var.vip_ip_configuration)}"
#}
