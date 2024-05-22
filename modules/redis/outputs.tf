output "redis_host" {
  value = azurerm_redis_cache.redis.hostname
}

output "redis_port" {
  value = azurerm_redis_cache.redis.port
}

output "redis_ssl_port" {
  value = azurerm_redis_cache.redis.ssl_port
}

output "redis_primary_key" {
  value = azurerm_redis_cache.redis.primary_access_key
  sensitive = true
}


output "redis_logdiagnostics_id" {
  value = azurerm_monitor_diagnostic_setting.diag_redis.id
}

output "redis_logdiagnostics_name" {
  value = azurerm_monitor_diagnostic_setting.diag_redis.name
}
