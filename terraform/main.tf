resource "azurerm_resource_group" "bootstrap" {
  name     = "${var.resource_group}-rg"
  location = var.location
}

resource "azurerm_storage_account" "bootstrap" {
  name                     = "${var.resource_group}strg"
  resource_group_name      = azurerm_resource_group.bootstrap.name
  location                 = azurerm_resource_group.bootstrap.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "bootstrap" {
  name                  = "${var.resource_group}-tfstate"
  storage_account_id    = azurerm_storage_account.bootstrap.id
  container_access_type = "private"
}

resource "azurerm_key_vault" "bootstrap" {
  name                = "${var.resource_group}-kv"
  location            = azurerm_resource_group.bootstrap.location
  resource_group_name = azurerm_resource_group.bootstrap.name

  enabled_for_disk_encryption = true
  purge_protection_enabled    = false
  soft_delete_retention_days  = 7

  sku_name  = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]
  }
}

resource "azurerm_key_vault_secret" "username" {
  name         = "user-name"
  value        = "adminuser"
  key_vault_id = azurerm_key_vault.bootstrap.id
}

resource "azurerm_key_vault_secret" "password" {
  name         = "user-password"
  value        = "0Navomvj1!@#$"
  key_vault_id = azurerm_key_vault.bootstrap.id
}
