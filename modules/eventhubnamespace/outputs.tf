output "eventhub_namespace_name" {
  value = azurerm_eventhub_namespace.eventhub_namespace.name
}

output "eventhub_namespace_id" {
  value = azurerm_eventhub_namespace.eventhub_namespace.id
}

output "eventhub_namespace_conn_string_lister" {
  value = azurerm_eventhub_namespace_authorization_rule.eventhub_namespace_auth_listen.primary_connection_string
}

output "eventhub_namespace_conn_string_send" {
  value = azurerm_eventhub_namespace_authorization_rule.eventhub_namespace_auth_send.primary_connection_string
}

output "eventhub_namespace_conn_string_manage" {
  value = azurerm_eventhub_namespace_authorization_rule.eventhub_namespace_auth_manage.primary_connection_string
}


output "eventhub_logdiagnostics_id" {
  value = azurerm_monitor_diagnostic_setting.diag_eventhub.id
}

output "eventhub_logdiagnostics_name" {
  value = azurerm_monitor_diagnostic_setting.diag_eventhub.name
}
