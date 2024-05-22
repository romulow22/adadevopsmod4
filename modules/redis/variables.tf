variable "location" {
  type        = string
  description = "The location where the Redis instance will be created"
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group"
}

variable "capacity" {
  type        = number
  description = "The size of the Redis cache"
}

variable "family" {
  type        = string
  description = "The family of the SKU to use"
}

variable "sku_name" {
  type        = string
  description = "The SKU of Redis cache to use"
}

variable "enable_non_ssl_port" {
  type        = bool
  description = "Specifies whether the non-ssl Redis server port (6379) is enabled"
  default     = false
}

variable "maxmemory_policy" {
  type        = string
  description = "The eviction policy for the Redis cache"
  default     = "allkeys-lru"
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

variable "public_network_access" {
  description = " Whether or not public network access is allowed for this Redis Cache. true means this resource could be accessed by both public and private endpoint. false means only private endpoint access is allowed. Defaults to true."
  type        = bool
}

variable "enable_authentication" {
  description = " (Optional) If set to false, the Redis instance will be accessible without authentication. Defaults to true."
  type        = bool
}

variable "rg_id"{
  type        = string
  description = "resource group id"
}


variable "aks_identity_principal_id"{
  type        = string
  description = "aks_identity_principal_id"
}

variable "workspace_id"{
  type        = string
  description = "workspace_id"
}