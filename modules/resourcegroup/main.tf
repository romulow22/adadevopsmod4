# create resource group 
resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${var.service_name}-${var.proj_name}-${var.environment}"
  location = var.location
  
  tags = {
    Environment = var.environment
  }
}
