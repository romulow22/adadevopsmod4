
# resource group name
output "rg_name" {
  value       = azurerm_resource_group.resource_group.name
  description = "Resource group name"
}


output "rg_id" {
  value       = azurerm_resource_group.resource_group.id
  description = "Resource group id"
}
