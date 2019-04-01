Deploys an F5 appliance from the Azure marketplace

Due to Terraform limitations we havent found a way of passing the
ip_configuration to the module as a list. This has required that the nic be
created outside the module its ID passed

Example
```
resource "azurerm_network_interface" "nic_vip" {
  name                = "f5-nic02"
  location            = "${azurerm_resource_group.rg_dmz.location}"
  resource_group_name = "${azurerm_resource_group.rg_dmz.name}"
  ip_configuration    = [
  {
    primary = "true"
    name    = "ip01"
    subnet_id = "${element(azurerm_subnet.subnet.*.id, index(azurerm_subnet.subnet.*.name, var.loadbalancer_sub    net_vip))}"
    private_ip_address_allocation = "dynamic"
  },
  {
    name    = "ip02"
    subnet_id = "${element(azurerm_subnet.subnet.*.id, index(azurerm_subnet.subnet.*.name, var.loadbalancer_sub    net_vip))}"
    private_ip_address_allocation = "dynamic"
  } ]
}

module "lb_1" {
  source         = "modules/f5"
  rg             = "rg-f5"
  vm_name        = "f5-01"
  subnet_mgmt_id = ["${azurerm_network_interface.nic_lbl_mgmt.id}"]
  vm_username    = "${var.vm_username}"
  vm_password    = "${var.vm_password}"
  nic_vip_id     = "${azurerm_network_interface.nic_vip.id}"
}
```
