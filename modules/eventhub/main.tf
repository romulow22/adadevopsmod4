# Create azure event hubs or Kafka Topics
resource "azurerm_eventhub" "eventhubs" {

  name                = "eh-${var.service_name}"
  namespace_name      = var.eh_ns_name
  resource_group_name = var.rg_name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
  

  depends_on = [ var.eh_ns_name ]
}


resource "azurerm_eventhub_consumer_group" "eventhub_consumergroup" {
   
  name                = "${var.service_name}-consumergroup"
  eventhub_name       = azurerm_eventhub.eventhubs.name
  namespace_name      = azurerm_eventhub.eventhubs.namespace_name
  resource_group_name = azurerm_eventhub.eventhubs.resource_group_name
  depends_on = [ azurerm_eventhub.eventhubs ]
}



