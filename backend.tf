# backend
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-ada"
    storage_account_name = "stgtfstateada001"
    container_name       = "tfstatecontainer"
    key                  = "terraform.tfstate"
  }
}
