resource "azurerm_public_ip" "pip_mgmt" {
  name                                      = "${var.vm_name}-${var.environment}-pip-${count.index}"
  location                                  = "${data.azurerm_resource_group.rg.location}"
  resource_group_name                       = "${data.azurerm_resource_group.rg.name}"
  allocation_method                         = "Static"
  tags                                      = "${var.tags}"
  count                                     = "2"
}

resource "azurerm_network_interface" "nic_mgmt" {
  name                                      = "${var.vm_name}-${var.environment}-mgmt-nic-${count.index}"
  location                                  = "${data.azurerm_resource_group.rg.location}"
  resource_group_name                       = "${data.azurerm_resource_group.rg.name}"
  tags                                      = "${var.tags}"
  count                                     = "2"
  ip_configuration {
    name                                    = "${var.vm_name}-${var.environment}-mgmt-nic-${count.index}"
    subnet_id                               = "${var.subnet_mgmt_id}"
    private_ip_address_allocation           = "dynamic"
    public_ip_address_id                    = "${element(azurerm_public_ip.pip_mgmt.*.id, count.index)}"
  }
}

resource "azurerm_network_interface" "nic_data" {
  name                                      = "${var.vm_name}-${var.environment}-data-nic-${count.index}"
  location                                  = "${data.azurerm_resource_group.rg.location}"
  resource_group_name                       = "${data.azurerm_resource_group.rg.name}"
  tags                                      = "${var.tags}"
  count                                     = "2"
  ip_configuration {
    name                                    = "${var.vm_name}-${var.environment}-data-nic-${count.index}"
    subnet_id                               = "${var.nic_vip_id}"
    private_ip_address_allocation           = "dynamic"
  }
}

output "public_ip_address" {
  value = "${azurerm_public_ip.pip_mgmt.*.ip_address}"
}
#resource "azurerm_network_interface" "nic_vip" {

#  name                                     = "${var.vm_name}-nic02"
#  location                                 = "${data.azurerm_resource_group.rg.location}"
#  resource_group_name                      = "${data.azurerm_resource_group.rg.name}"
##  ip_configuration                        = "${var.vip_ip_configuration}"
#  ip_configuration                         = "${element(var.vip_ip_configuration)}"
#}
