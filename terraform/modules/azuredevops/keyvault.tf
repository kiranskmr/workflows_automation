# resource "random_pet" "rg_name" {
#   prefix = var.resource_group_name_prefix
# }

# resource "azurerm_resource_group" "rg" {
#   name     = azurerm_resource_group.resource_group.name
#   location = var.resource_group_location
# }


resource "random_id" "names" {
  byte_length = 8
}

locals {
  current_user_id = coalesce(var.msi_id, data.azurerm_client_config.current.object_id)
}

resource "azurerm_key_vault" "vault" {
  name                       = "tfkv${lower(random_id.names.hex)}"
  location                   = azurerm_resource_group.resource_group.location
  resource_group_name        = azurerm_resource_group.resource_group.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = local.current_user_id

    key_permissions    = var.key_permissions
    secret_permissions = var.secret_permissions
  }
  tags = {
    removeAfter = "2024-12-31",
    owner = data.azuread_user.current_user.user_principal_name
  }
}

resource "random_string" "azurerm_key_vault_key_name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_key_vault_key" "key" {
  name = coalesce(var.key_name, "key-${random_string.azurerm_key_vault_key_name.result}")

  key_vault_id = azurerm_key_vault.vault.id
  key_type     = var.key_type
  key_size     = var.key_size
  key_opts     = var.key_ops

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
}

resource "azurerm_key_vault_secret" "accesskey" {
  name         = "ARM-ACCESS-KEY"
  value        = azurerm_storage_account.storage_account.primary_access_key
  key_vault_id = azurerm_key_vault.vault.id
}