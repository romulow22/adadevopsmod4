# Storage Account Name
output "storage_account_name" {
  value       = azurerm_storage_account.storage_account.name
  description = "Name of the Storage Account"
}

# Storage Account ID
output "storage_account_id" {
  value       = azurerm_storage_account.storage_account.id
  description = "ID of the Storage Account"
}

# Storage Account CString
output "storage_account_conn_string" {
  value       = azurerm_storage_account.storage_account.primary_connection_string
  description = "Connection String of the Storage Account"
}


# Storage Container Name
output "storage_container_name" {
  value       = azurerm_storage_container.storage_container.name
  description = "Name of the Storage Container"
}

output "storage_container_id" {
  value       = azurerm_storage_container.storage_container.id
  description = "ID of the Storage Container"
}

output "storage_share_name" {
  value       = azurerm_storage_share.storage_share.name
  description = "Name of the Storage Share"
}

output "storage_share_id" {
  value       = azurerm_storage_share.storage_share.id
  description = "ID of the Storage Share"
}

output "storage_share_url" {
  value       = azurerm_storage_share.storage_share.url
  description = "URL of the Storage Share"
}

output "storage_logdiagnostics_id" {
  value = azurerm_monitor_diagnostic_setting.diag_storage.id
}

output "storage_logdiagnostics_name" {
  value = azurerm_monitor_diagnostic_setting.diag_storage.name
}



