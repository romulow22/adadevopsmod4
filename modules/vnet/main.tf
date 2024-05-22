# create virtual network 
resource "azurerm_virtual_network" "virtual_network" {
  name                = "vnet-${var.environment}-${var.environment}"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = var.address_space
  depends_on          = [var.rg_name]

  tags = {
    Environment = var.environment
  }
}

