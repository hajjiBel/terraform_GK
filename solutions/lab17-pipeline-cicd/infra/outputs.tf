output "website_url" {
  description = "Adresse du site statique"
  value       = azurerm_storage_account.web.primary_web_endpoint
}

output "storage_account" {
  value = azurerm_storage_account.web.name
}
