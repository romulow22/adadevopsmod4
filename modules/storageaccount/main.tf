resource "azurerm_storage_account" "storage_account" {
  name                      = "stg${var.proj_name}${var.environment}"
  resource_group_name       = var.rg_name
  location                  = var.location
  access_tier               = var.access_tier
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.replication_type
  is_hns_enabled            = false
  enable_https_traffic_only = true
  network_rules {
    default_action       =  var.default_action
  }

  identity {
    type = "SystemAssigned"
  }
  tags = {
    environment = var.environment
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  depends_on = [
    var.rg_name
  ]
}


resource "azurerm_storage_container" "storage_container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = var.container_access_type
  depends_on = [
    azurerm_storage_account.storage_account
  ]
}


resource "azurerm_storage_share" "storage_share" {
  name                 = var.file_share_name
  storage_account_name = azurerm_storage_account.storage_account.name
  quota                = var.file_share_quota 
  depends_on = [
    azurerm_storage_account.storage_account
  ]
}

resource "azurerm_role_assignment" "storage_role" {
  scope                = var.rg_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.aks_identity_principal_id
}

# Create diagnostic settings for Storage Account
resource "azurerm_monitor_diagnostic_setting" "diag_storage" {
  name                       = "diag-${azurerm_storage_account.storage_account.name}"
  target_resource_id         = azurerm_storage_account.storage_account.id
  log_analytics_workspace_id = var.workspace_id

  metric {
    category = "Transaction"
  }

  lifecycle {
    ignore_changes = [
      log,
      metric
    ]
  }
  depends_on = [
    azurerm_storage_account.storage_account,
    var.workspace_id
  ]
}