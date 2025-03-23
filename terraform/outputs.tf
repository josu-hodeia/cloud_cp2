output "public_ip" {
  description = "Dirección IP pública de la MV"
  value       = azurerm_public_ip.vm_public_ip.ip_address
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}