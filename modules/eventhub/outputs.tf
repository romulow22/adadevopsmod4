output "eventhub_name" {
  value =  azurerm_eventhub.eventhubs.name
}

output "eventhub_id" {
  value = azurerm_eventhub.eventhubs.id
}

output "eventhub_status" {
  value = azurerm_eventhub.eventhubs.status
}

output "eventhub_consumergroup_id" {
  value = azurerm_eventhub_consumer_group.eventhub_consumergroup.id
}

output "eventhub_consumergroup_name" {
  value = azurerm_eventhub_consumer_group.eventhub_consumergroup.name
}

