resource "azurerm_virtual_machine" "vm" {
  name = "${var.vm_name}"
  location = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  vm_size = "${var.vm_size}"
  network_interface_ids = ["${azurerm_network_interface.nic_mgmt.id}", "${var.nic_vip_id}"]
  primary_network_interface_id = "${azurerm_network_interface.nic_mgmt.id}"
  storage_image_reference {
    publisher = "f5-networks"
    offer = "f5-big-ip-best"
    sku = "${var.vm_sku}"
    version = "latest"
  }
  plan {
    publisher = "f5-networks"
    product = "f5-big-ip-best"
    name = "${var.vm_sku}"
  }
  storage_os_disk {
    name              = "${var.vm_disk_name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.vm_osprofile_computer_name}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}
