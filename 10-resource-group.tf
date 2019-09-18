resource "azurerm_resource_group" "f5-rg" {
  name     = "${var.loadbalancer_rg_name}"
  location = "${var.location}"
}
