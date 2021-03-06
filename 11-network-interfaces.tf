
resource "azurerm_network_interface" "nic_mgmt" {
  name                                      = "${var.vm_name}-${var.environment}-nic01"
  location                                  = "${data.azurerm_resource_group.rg.location}"
  resource_group_name                       = "${data.azurerm_resource_group.rg.name}"
  tags                                      = "${var.tags}"
  ip_configuration {
    name                                    = "${var.vm_name}-${var.environment}-nic02-ip01"
    subnet_id                               = "${var.subnet_mgmt_id}"
    private_ip_address_allocation           = "dynamic"
    public_ip_address_id                    = "${azurerm_public_ip.pip_mgmt.id}"
  }
}

resource "azurerm_public_ip" "pip_mgmt" {
  name                                      = "${var.vm_name}-${var.environment}-nic01-pip"
  location                                  = "${data.azurerm_resource_group.rg.location}"
  resource_group_name                       = "${data.azurerm_resource_group.rg.name}"
  allocation_method                         = "Static"
  sku                                       = "Standard"	
  tags                                      = "${var.tags}"
}

