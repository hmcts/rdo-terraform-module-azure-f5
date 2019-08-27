output "lb_public_ip" {
  value = azurerm_public_ip.pip_lb.ip_address
}
