resource "azurerm_virtual_machine" "vm" {
  name                                  = "${var.vm_name}-${var.environment}-vm-${count.index}"
  location                              = "${data.azurerm_resource_group.rg.location}"
  resource_group_name                   = "${data.azurerm_resource_group.rg.name}"
  vm_size                               = "${var.vm_size}"
  network_interface_ids                 = ["${element(azurerm_network_interface.nic_mgmt.*.id, count.index)}", "${element(azurerm_network_interface.nic_data.*.id, count.index)}"]
  primary_network_interface_id          = "${element(azurerm_network_interface.nic_mgmt.*.id, count.index)}"
  delete_os_disk_on_termination         = true
  tags                                  = "${var.tags}"
  count                                 = 2
  availability_set_id                   = "${azurerm_availability_set.availability_set.id}"

  storage_image_reference {
    publisher                           = "f5-networks"
    offer                               = "f5-big-ip-best"
    sku                                 = "${var.vm_sku}"
    version                             = "14.003000" #"latest" - lastest 14.0.003xxx - takes too long to provision
  }
  plan {
    publisher                           = "f5-networks"
    product                             = "f5-big-ip-best"
    name                                = "${var.vm_sku}"
  }
  storage_os_disk {
    name                                = "${var.vm_name}-${var.environment}-os-${count.index}"
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

resource "azurerm_availability_set" "availability_set" {
  name                         = "${var.vm_name}-${var.environment}-AS"
  resource_group_name          = "${data.azurerm_resource_group.rg.name}"
  location                     = "${data.azurerm_resource_group.rg.location}"
  managed                      = true
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  tags                         = "${var.tags}"
}

data "template_file" "inventory" {
    template                            = "${file("${path.module}/templates/inventory.tpl")}"

    depends_on = [
        "azurerm_virtual_machine.vm"
    ]

    vars = {
        admin_username                  = "${var.vm_username}"
        admin_password                  = "${var.vm_password}"
        public_ip1                      = "${azurerm_public_ip.pip_mgmt.0.ip_address}"
        public_ip2                      = "${azurerm_public_ip.pip_mgmt.1.ip_address}"
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
      echo "ls ansible dir"
      ls -al ${path.module}/ansible
      echo "find inventory"
      find . -name inventory
      echo "find f5.yml"
      find . -name f5.yml
      echo "cat inventory"
      cat ./.terraform/modules/f5-01/ansible/inventory
      echo "cat f5.yml"
      cat ./.terraform/modules/f5-01/ansible/f5.yml
      echo "ansible version"
      ansible --version
      git clone https://github.com/f5devcentral/f5-asm-policy-template-v13.git;
      az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
      az storage blob download-batch -d ${path.module}/ansible/ --pattern star*.* -s certs --account-name dmzsandbox01
      echo "finding Certs"
      find . -name star-platform-hmcts-net.crt
      find . -name star-platform-hmcts-net.key
      echo "Galaxy F5 playbook install"
      ansible-galaxy install -f f5devcentral.f5ansible
      echo "F5 Playbook Run"
      ansible-playbook -i ${path.module}/ansible/inventory -vvvvvv ${path.module}/ansible/f5.yml -l f5 --extra-vars '{"provider":{"server": "${azurerm_public_ip.pip_mgmt.0.ip_address}", "server_port":"443", "user":"${var.vm_username}", "password":"${var.vm_password}", "validate_certs":"no", "timeout":"300"}}' --extra-vars 'f5_selfip="${azurerm_network_interface.nic_data.0.private_ip_address}"' --extra-vars 'f5_selfsubnet="${var.selfip_subnet}"' --extra-vars 'as3_username="${var.as3_username}"' --extra-vars 'as3_password="${var.as3_password}"' --extra-vars 'default_gateway="${local.default_gateway}"' && \
      ansible-playbook -i ${path.module}/ansible/inventory -vv ${path.module}/ansible/f5.yml -l f52 --extra-vars '{"provider":{"server": "${azurerm_public_ip.pip_mgmt.1.ip_address}", "server_port":"443", "user":"${var.vm_username}", "password":"${var.vm_password}", "validate_certs":"no", "timeout":"300"}}' --extra-vars 'f5_selfip="${azurerm_network_interface.nic_data.1.private_ip_address}"' --extra-vars 'f5_selfsubnet="${var.selfip_subnet}"' --extra-vars 'as3_username="${var.as3_username}"' --extra-vars 'as3_password="${var.as3_password}"' --extra-vars 'default_gateway="${local.default_gateway}"'
      EOF
  }
}