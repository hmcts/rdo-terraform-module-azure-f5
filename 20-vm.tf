resource "azurerm_virtual_machine" "vm" {
  name                                  = "${var.vm_name}-${var.environment}"
  location                              = "${data.azurerm_resource_group.rg.location}"
  resource_group_name                   = "${data.azurerm_resource_group.rg.name}"
  vm_size                               = "${var.vm_size}"
  network_interface_ids                 = ["${azurerm_network_interface.nic_mgmt.id}", "${var.nic_vip_id}"]
  primary_network_interface_id          = "${azurerm_network_interface.nic_mgmt.id}"
  delete_os_disk_on_termination         = true
  tags                                  = "${var.tags}"

  storage_image_reference {
    publisher                           = "f5-networks"
    offer                               = "f5-big-ip-best"
    sku                                 = "${var.vm_sku}"
    version                             = "14.0.001000" #"latest" - lastest 14.0.003xxx - takes too long to provision
  }
  plan {
    publisher                           = "f5-networks"
    product                             = "f5-big-ip-best"
    name                                = "${var.vm_sku}"
  }
  storage_os_disk {
    name                                = "${var.vm_name}-${var.environment}-os"
    caching                             = "ReadWrite"
    create_option                       = "FromImage"
    managed_disk_type                   = "Standard_LRS"
  }
  os_profile {
    computer_name                       = "${var.vm_name}"
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

data "template_file" "inventory" {
    template                            = "${file("${path.module}/templates/inventory.tpl")}"

    depends_on = [
        "azurerm_virtual_machine.vm"
    ]

    vars = {
        admin_username                  = "${var.vm_username}"
        admin_password                  = "${var.vm_password}"
        public_ip                       = "${azurerm_public_ip.pip_mgmt.ip_address}"
    }
}

resource "null_resource" "update_inventory" {

    triggers = {
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
      git clone --progress --verbose https://github.com/hmcts/rdo-terraform-module-azure-f5.git
      pwd
      ls -al ${path.module}
      ls -al ${path.module}/.terraform
      ls -al ${path.module}/ansible
      #cd rdo-terraform-module-azure-f5/ansible;
      #git clone https://github.com/f5devcentral/f5-asm-policy-template-v13.git;
      #sleep 30;
      #ls -alR ${path.module}/.terraform
      #cat ${path.module}/ansible/inventory;
      #cat ${path.module}/ansible/f5.yml;
      #az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
      #az storage blob download-batch -d . --pattern star*.* -s certs --account-name dmzsandbox01
      #ansible-galaxy install -f f5devcentral.f5ansible
      #ansible-playbook -i ${path.module}/ansible/inventory -vvvvvvv ${path.module}/ansible/f5.yml --extra-vars '{"provider":{"server": "${azurerm_public_ip.pip_mgmt.ip_address}", "server_port":"443", "user":"${var.vm_username}", "password":"${var.vm_password}", "validate_certs":"no", "timeout":"300"}}' --extra-vars 'f5_selfip="${var.selfip_private_ip}"' --extra-vars 'f5_selfsubnet="${var.selfip_subnet}"' --extra-vars 'as3_username="${var.as3_username}"' --extra-vars 'as3_password="${var.as3_password}"' --extra-vars 'default_gateway="${local.default_gateway}"'
      EOF
  }
}