
output "Resource_Group_Name" {
  value = azurerm_resource_group.resource_group.name
}

output "Storage_Account_Name" {
  value = azurerm_storage_account.storage_account.name
}

output "Container_Name" {
  value = azurerm_storage_data_lake_gen2_filesystem.container.name
}

output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}

output "azurerm_key_vault_name" {
  value = azurerm_key_vault.vault.name
}

output "azurerm_key_vault_id" {
  value = azurerm_key_vault.vault.id
}