resource "azurerm_resource_group" "f5-rg" {
  name     = "${var.loadblancer_rg_name}"
  location = "${var.location}"
}
