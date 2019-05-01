data "azurerm_key_vault_secret" "ssh-public-key" {
name                                    = "ssh-public-key"
vault_uri                               = "${var.key_vault_uri}"
}


resource "azurerm_virtual_machine" "vm" {
  name                                  = "${var.vm_name}"
  location                              = "${data.azurerm_resource_group.rg.location}"
  resource_group_name                   = "${data.azurerm_resource_group.rg.name}"
  vm_size                               = "${var.vm_size}"
  network_interface_ids                 = ["${azurerm_network_interface.nic_mgmt.id}", "${var.nic_vip_id}"]
  primary_network_interface_id          = "${azurerm_network_interface.nic_mgmt.id}"
  delete_os_disk_on_termination         = true
  storage_image_reference {
    publisher                           = "f5-networks"
    offer                               = "f5-big-ip-best"
    sku                                 = "${var.vm_sku}"
    version                             = "latest"
  }
  plan {
    publisher                           = "f5-networks"
    product                             = "f5-big-ip-best"
    name                                = "${var.vm_sku}"
  }
  storage_os_disk {
    name                                = "${var.vm_disk_name}"
    caching                             = "ReadWrite"
    create_option                       = "FromImage"
    managed_disk_type                   = "Standard_LRS"
  }
  os_profile {
    computer_name                       = "${var.vm_osprofile_computer_name}"
    admin_username                      = "${var.vm_username}"
    admin_password                      = "${var.vm_password}"
  }
  os_profile_linux_config {
    disable_password_authentication     = false
  ssh_keys {
    path                                = "/home/${var.vm_username}/.ssh/authorized_keys"
    key_data                            = "${data.azurerm_key_vault_secret.ssh-public-key.value}"
  }
  }
}

#data "template_file" "inventory" {
#    template                            = "${file("${path.module}/templates/inventory.tpl")}"

#    depends_on = [
#        "azurerm_virtual_machine.vm"
#    ]

#    vars {
#        admin_username                  = "${var.vm_username}"
#        admin_password                  = "${var.vm_password}"
#        public_ip                       = "${azurerm_public_ip.pip_mgmt.ip_address}"
#    }
#}

#resource "null_resource" "update_inventory" {

 #   triggers {
#        template                        = "${data.template_file.inventory.rendered}"
#    }

#    provisioner "local-exec" {
#        command                         = "echo '${data.template_file.inventory.rendered}' > ${path.module}/ansible/inventory"
#    }
#}

#resource "null_resource" "ansible-runs" {
#    triggers = {
#      always_run                        = "${timestamp()}"
#    }

#    depends_on = [
#        "azurerm_virtual_machine.vm",
#        "azurerm_network_interface.nic_mgmt",
#        "azurerm_public_ip.pip_mgmt"
#    ]

#  provisioner "local-exec" {
#    command = <<EOF
#      git clone https://github.com/hmcts/rdo-terraform-module-azure-f5.git;
#      cd rdo-terraform-module-azure-f5/ansible;
#      sleep 30;
#      ansible-playbook -i inventory f5.yml --extra-vars '{"provider":{"server": "${azurerm_public_ip.pip_mgmt.ip_address}", "server_port":"443", "user":"${var.vm_username}", "password":"${var.vm_password}", "validate_certs":"no", "timeout":"300"}}'
#      EOF
#  }
#}