variable "proj_name" {
  description = "Project name"
  type        = string
}

variable "location" {
  description = "Location for the Event Hub"
  type        = string
}

variable "rg_name" {
  description = "Resource group name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "sku_name" {
  description = "SKU tier"
  type        = string
}

variable "aks_identity_principal_id"{
  type        = string
  description = "aks_identity_principal_id"
}


variable "capacity"{
  type        = string
  description = "capacity"
}

variable "rg_id"{
  type        = string
  description = "resource group id"
}

variable "workspace_id"{
  type        = string
  description = "workspace_id"
}