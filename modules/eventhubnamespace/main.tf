resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  name                = "ehns-${var.proj_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.sku_name
  capacity            = var.capacity
  public_network_access_enabled = true
  local_authentication_enabled = true
  maximum_throughput_units = 20
  auto_inflate_enabled = true
  tags = {
    environment = var.environment
  }
  depends_on = [var.rg_name]
}


resource "azurerm_eventhub_namespace_authorization_rule" "eventhub_namespace_auth_send" {
  name                = "appsend"
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  resource_group_name = var.rg_name

  listen = true
  send   = true
  manage = false

  depends_on = [ azurerm_eventhub_namespace.eventhub_namespace ]
}


resource "azurerm_eventhub_namespace_authorization_rule" "eventhub_namespace_auth_listen" {
  name                = "applisten"
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  resource_group_name = var.rg_name

  listen = true
  send   = false
  manage = false

  depends_on = [ azurerm_eventhub_namespace.eventhub_namespace ]
}


resource "azurerm_eventhub_namespace_authorization_rule" "eventhub_namespace_auth_manage" {
  name                = "appmanage"
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  resource_group_name = var.rg_name

  listen = true
  send   = true
  manage = true

  depends_on = [ azurerm_eventhub_namespace.eventhub_namespace ]
}


resource "azurerm_role_assignment" "event_hubs_role" {
  scope                = var.rg_id
  role_definition_name = "Azure Event Hubs Data Owner"
  principal_id         = var.aks_identity_principal_id
}



# Create azure event hub namespace diagnostic settings using terraform
resource "azurerm_monitor_diagnostic_setting" "diag_eventhub" {
  name                       = "diag-${azurerm_eventhub_namespace.eventhub_namespace.name}"
  target_resource_id         = azurerm_eventhub_namespace.eventhub_namespace.id
  log_analytics_workspace_id = var.workspace_id
  
  enabled_log {
    category_group = "allLogs"

  }

  metric {
    category = "AllMetrics"
    enabled = false

  }


  lifecycle {
    ignore_changes = [
      enabled_log,metric
    ]
  }

  depends_on = [
    azurerm_eventhub_namespace.eventhub_namespace,
    var.workspace_id
  ]
}


