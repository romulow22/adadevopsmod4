output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace."
  value       = { for k, v in azurerm_log_analytics_workspace.workspace : k => v.id }
}

output "log_analytics_workspace_location" {
  description = "Specifies the location of the log analytics workspace"
  value       = { for k, v in azurerm_log_analytics_workspace.workspace : k => v.location }
}

output "log_analytics_workspace_name" {
  description = "Specifies the name of the log analytics workspace"
  value       = { for k, v in azurerm_log_analytics_workspace.workspace : k => v.name }
}

output "log_analytics_workspace_resource_group_name" {
  description = "Specifies the name of the resource group that contains the log analytics workspace"
  value       = { for k, v in azurerm_log_analytics_workspace.workspace : k => v.resource_group_name }
}

output "log_analytics_workspace_workspace_id" {
  description = "Specifies the workspace id of the log analytics workspace"
  value       = { for k, v in azurerm_log_analytics_workspace.workspace : k => v.workspace_id }
}

output "log_analytics_workspace_primary_shared_key" {
  description = "Specifies the workspace key of the log analytics workspace"
  value       = { for k, v in azurerm_log_analytics_workspace.workspace : k => v.primary_shared_key }
  sensitive   = true
}