resource "azurerm_redis_cache" "redis" {
  name                          = "redis-${var.proj_name}-${var.environment}"
  location                      = var.location
  resource_group_name           = var.rg_name
  capacity                      = var.capacity
  family                        = var.family
  sku_name                      =  var.sku_name
  minimum_tls_version           = "1.2"
  enable_non_ssl_port           = false
  public_network_access_enabled = var.public_network_access
  
  redis_configuration {
    maxmemory_policy      = var.maxmemory_policy
    enable_authentication = var.enable_authentication
    maxmemory_reserved = 125
    maxmemory_delta    = 125
    active_directory_authentication_enabled = true
  }

  tags = {
    Environment = var.environment
  }

  depends_on = [var.rg_name]

}

resource "azurerm_redis_cache_access_policy_assignment" "redis_access_policy" {
  name               = "aks_identity_assignment"
  redis_cache_id     = azurerm_redis_cache.redis.id
  access_policy_name = "Data Owner"
  object_id          = var.aks_identity_principal_id
  object_id_alias    = "ServicePrincipal"
}

resource "azurerm_role_assignment" "redis_role" {
  scope                = var.rg_id
  role_definition_name = "Contributor"
  principal_id         = var.aks_identity_principal_id
}

# Create diagnostic settings for Azure Cache for Redis
resource "azurerm_monitor_diagnostic_setting" "diag_redis" {
  name                       = "diag-${azurerm_redis_cache.redis.name}"
  target_resource_id         = azurerm_redis_cache.redis.id
  log_analytics_workspace_id = var.workspace_id

  enabled_log {
    category = "ConnectedClientList"
    
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
    azurerm_redis_cache.redis,
    var.workspace_id
  ]
}