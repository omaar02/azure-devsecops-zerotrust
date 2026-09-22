output "resource_group_name" {
  description = "Nome del Resource Group creato"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_id" {
  description = "Resource ID univoco su Azure"
  value       = azurerm_resource_group.rg.id
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "key_vault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}
