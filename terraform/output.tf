output "resource_group_name" {
  description = "The name of the resource group."
  value       = azurerm_resource_group.bootstrap.name
}

output "storage_account_name" {
  description = "The name of the storage account."
  value       = azurerm_storage_account.bootstrap.name
}

output "storage_container_name" {
  description = "The name of the storage account."
  value       = azurerm_storage_container.bootstrap.name
}

output "key_vault_name" {
  description = "The name of the Key Vault."
  value       = azurerm_key_vault.bootstrap.name
}
