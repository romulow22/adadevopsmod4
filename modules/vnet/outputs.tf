# virtual network ID
output "vnetID" {
  value       = azurerm_virtual_network.virtual_network.id
  description = "ID of virtual network"
}

# resource group name
output "vnet_name" {
  value       = azurerm_virtual_network.virtual_network.name
  description = "Vnet name"
}

