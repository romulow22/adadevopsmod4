# location
variable "location" {
  type        = string
  description = "Location of the resources"
}

# vnet CIDR
variable "address_space" {
  type        = list(string)
  description = "CIDR of the vnet"
}

# environment
variable "environment" {
  type        = string
  description = "Environment"
}

variable "proj_name"{
  type        = string
  description = "project Name"
}


variable "rg_name"{
  type        = string
  description = "resource group name"
}
