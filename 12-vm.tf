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
    version                             = "14.0.001000" #"latest"
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
    #ssh_keys {
    #  path                                = "/home/${var.vm_username}/.ssh/authorized_keys"
    #  key_data                            = "${file("${var.ssh_public_key}")}"
    #}
  }
}


resource "azurerm_virtual_machine_extension" "vm_exts_bootstrap" {
 count = 2
 name                 = "f5bigip_1nic_ha_fo_bootstrap"
 location             = "${data.azurerm_resource_group.rg.location}"
 resource_group_name  = "${data.azurerm_resource_group.rg.name}"
 virtual_machine_name = "${element(azurerm_virtual_machine.vm.*.name, count.index)}"
 publisher            = "Microsoft.Azure.Extensions"
 type                 = "CustomScript"
 type_handler_version = "2.0"

 settings = <<SETTINGS
   {
       "commandToExecute": "bigstart restart mcpd && sleep 60 && tmsh modify sys db configsync.allowmanagement value enable && tmsh modify sys db provision.1nic value forced_enable && tmsh modify sys global-settings hostname ${element(azurerm_virtual_machine.vm.*.name, count.index)}.local && tmsh mv cm device bigip1 ${element(azurerm_virtual_machine.vm.*.name, count.index)} && echo tmsh modify ltm virtual _cloud_lb_probe_listener_ enabled>>/config/failover/active;echo tmsh modify ltm virtual _cloud_lb_probe_listener_ disabled>>/config/failover/standby;tmsh -q create ltm virtual _cloud_lb_probe_listener_ destination ${element(azurerm_network_interface.nic_mgmt.*.private_ip_address, count.index)}:694 source 168.63.129.16/32 ip-protocol tcp"
   }
 SETTINGS
}

/*
data "template_file" "inventory" {
    template                            = "${file("${path.module}/templates/inventory.tpl")}"

    depends_on = [
        "azurerm_virtual_machine.vm"
    ]

    vars {
        admin_username                  = "${var.vm_username}"
        admin_password                  = "${var.vm_password}"
        public_ip                       = "${azurerm_public_ip.pip_mgmt.ip_address}"
    }
}

resource "null_resource" "update_inventory" {

    triggers {
        template                        = "${data.template_file.inventory.rendered}"
    }

    provisioner "local-exec" {
        command                         = "echo '${data.template_file.inventory.rendered}' > ${path.module}/ansible/inventory"
    }
}

resource "null_resource" "ansible-runs" {
    triggers = {
      always_run                        = "${timestamp()}"
    }

    depends_on = [
        "azurerm_virtual_machine.vm",
        "azurerm_network_interface.nic_mgmt",
        "azurerm_public_ip.pip_mgmt"
    ]

  provisioner "local-exec" {
    command = <<EOF
      git clone https://github.com/hmcts/rdo-terraform-module-azure-f5.git;
      cd rdo-terraform-module-azure-f5/ansible;
      sleep 30;
      ansible-playbook -i ${path.module}/ansible/inventory f5.yml --extra-vars '{"provider":{"server": "${azurerm_public_ip.pip_mgmt.ip_address}", "server_port":"443", "user":"${var.vm_username}", "password":"${var.vm_password}", "validate_certs":"no", "timeout":"300"}}' --extra-vars 'f5_selfip="${var.selfip_private_ip}"' --extra-vars 'f5_selfsubnet="${var.selfip_subnet}"'
      EOF
  }
}

*/