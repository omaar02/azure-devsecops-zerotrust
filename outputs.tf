output "resource_group_name" {
  description = "Nome del Resource Group creato"
  value       = azurerm_resource_group.rg1.name
}

output "resource_group_id" {
  description = "Resource ID univoco su Azure"
  value       = azurerm_resource_group.rg1.id
}