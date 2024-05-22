# subnetname
output "public_subnet_name" {
  value       = azurerm_subnet.public_subnet.name
  description = "ID of virtual network"
}

# vnet public subnets
output "public_subnet_id" {
  value       = azurerm_subnet.public_subnet.id
  description = "Public Subnet ID"
}

output "nsgID" {
  value       = azurerm_network_security_group.public_nsg.id
  description = "ID of the nsg"
}

