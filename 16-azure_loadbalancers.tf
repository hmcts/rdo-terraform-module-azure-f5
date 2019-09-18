resource "azurerm_public_ip" "pip_lb" {
  name                                      = "${var.vm_name}-${var.environment}-lb-pip"
  location                                  = "${azurerm_resource_group.f5-rg.location}"
  resource_group_name                       = "${azurerm_resource_group.f5-rg.name}"
  allocation_method                         = "Static"
  tags                                      = "${var.tags}"
#  sku                                       = "Standard"
}

resource "azurerm_lb" "f5_ext_lb" {
  resource_group_name = "${azurerm_resource_group.f5-rg.name}"
  name                = "${var.vm_name}-${var.environment}-elb"
  location            = "${azurerm_resource_group.f5-rg.location}"
 # sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "LoadBalancerFrontEnd"
    public_ip_address_id          = "${azurerm_public_ip.pip_lb.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  resource_group_name = "${azurerm_resource_group.f5-rg.name}"
  loadbalancer_id     = "${azurerm_lb.f5_ext_lb.id}"
  name                = "F5BackendPool1"
}

resource "azurerm_lb_rule" "smtp-25-rule" {
  resource_group_name             = "${azurerm_resource_group.f5-rg.name}"
  loadbalancer_id                 = "${azurerm_lb.f5_ext_lb.id}"
  name                            = "SMTP-25-LBRule"
  protocol                        = "tcp"
  frontend_port                   = 25
  backend_port                    = 25
  frontend_ip_configuration_name  = "LoadBalancerFrontEnd"
  enable_floating_ip             = false
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.backend_pool.id}"
  probe_id                       = "${azurerm_lb_probe.smtp-25-probe.id}"
}

resource "azurerm_lb_rule" "imap-143-rule" {
  resource_group_name             = "${azurerm_resource_group.f5-rg.name}"
  loadbalancer_id                 = "${azurerm_lb.f5_ext_lb.id}"
  name                            = "IMAP-143-LBRule"
  protocol                        = "tcp"
  frontend_port                   = 143
  backend_port                    = 143
  frontend_ip_configuration_name  = "LoadBalancerFrontEnd"
  enable_floating_ip             = false
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.backend_pool.id}"
  probe_id                       = "${azurerm_lb_probe.imap-143-probe.id}"
}

resource "azurerm_lb_rule" "imaps-993-rule" {
  resource_group_name             = "${azurerm_resource_group.f5-rg.name}"
  loadbalancer_id                 = "${azurerm_lb.f5_ext_lb.id}"
  name                            = "IMAPS-993-LBRule"
  protocol                        = "tcp"
  frontend_port                   = 993
  backend_port                    = 993
  frontend_ip_configuration_name  = "LoadBalancerFrontEnd"
  enable_floating_ip             = false
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.backend_pool.id}"
  probe_id                       = "${azurerm_lb_probe.imaps-993-probe.id}"
}

resource "azurerm_lb_rule" "smtp-465-rule" {
  resource_group_name             = "${azurerm_resource_group.f5-rg.name}"
  loadbalancer_id                 = "${azurerm_lb.f5_ext_lb.id}"
  name                            = "SMTP-465-LBRule"
  protocol                        = "tcp"
  frontend_port                   = 465
  backend_port                    = 465
  frontend_ip_configuration_name  = "LoadBalancerFrontEnd"
  enable_floating_ip             = false
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.backend_pool.id}"
  probe_id                       = "${azurerm_lb_probe.smtp-465-probe.id}"
}

resource "azurerm_lb_rule" "starttls-587-rule" {
  resource_group_name             = "${azurerm_resource_group.f5-rg.name}"
  loadbalancer_id                 = "${azurerm_lb.f5_ext_lb.id}"
  name                            = "STARTTLS-587-LBRule"
  protocol                        = "tcp"
  frontend_port                   = 587
  backend_port                    = 587
  frontend_ip_configuration_name  = "LoadBalancerFrontEnd"
  enable_floating_ip             = false
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.backend_pool.id}"
  probe_id                       = "${azurerm_lb_probe.starttls-587-probe.id}"
}

resource "azurerm_lb_probe" "smtp-25-probe" {
  resource_group_name = "${azurerm_resource_group.f5-rg.name}"
  loadbalancer_id     = "${azurerm_lb.f5_ext_lb.id}"
  name                = "SMTP-25-probe"
  port                = 25
  interval_in_seconds = 5
}

resource "azurerm_lb_probe" "imap-143-probe" {
  resource_group_name = "${azurerm_resource_group.f5-rg.name}"
  loadbalancer_id     = "${azurerm_lb.f5_ext_lb.id}"
  name                = "IMAP-143-probe"
  port                = 143
  interval_in_seconds = 5
}

resource "azurerm_lb_probe" "imaps-993-probe" {
  resource_group_name = "${azurerm_resource_group.f5-rg.name}"
  loadbalancer_id     = "${azurerm_lb.f5_ext_lb.id}"
  name                = "IMAPS-993-probe"
  port                = 993
  interval_in_seconds = 5
}

resource "azurerm_lb_probe" "smtp-465-probe" {
  resource_group_name = "${azurerm_resource_group.f5-rg.name}"
  loadbalancer_id     = "${azurerm_lb.f5_ext_lb.id}"
  name                = "SMTP-465-probe"
  port                = 465
  interval_in_seconds = 5
}

resource "azurerm_lb_probe" "starttls-587-probe" {
  resource_group_name = "${azurerm_resource_group.f5-rg.name}"
  loadbalancer_id     = "${azurerm_lb.f5_ext_lb.id}"
  name                = "STARTTLS-587-probe"
  port                = 587
  interval_in_seconds = 5
}
