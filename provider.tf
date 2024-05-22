# Azure Provider
terraform {
  required_version = ">=1.7.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  client_id               = var.client_id
  client_certificate_path = var.client_certificate_path
  tenant_id               = var.tenant_id
  subscription_id         = var.subscription_id

}


provider "helm" {
  kubernetes {
    config_path = "${path.module}/secrets/kubeconfig.yaml"
  }
}

