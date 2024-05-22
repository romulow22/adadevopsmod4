# subnet CIDRs
variable "subnet_address_prefix" {
  type        = list(string)
  description = "CIDR of subnet"
}

variable "rg_name"{
  type        = string
  description = "rg Name"
}

variable "vnet_name"{
  type        = string
  description = "vnet Name"
}

variable "subnet_name"{
  type        = string
  description = "subnet_name"
}

# location
variable "location" {
  type        = string
  description = "location of the resources"
}

# environment
variable "environment" {
  type        = string
  description = "environment"
}

variable "proj_name"{
  type        = string
  description = "project Name"
}