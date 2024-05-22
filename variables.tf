variable "resource_groups" {
  description = "Map of resource groups to create"
  type        = map(string)
}

# region
variable "region" {
  type        = string
  description = "Region"
}

variable "project_name" {
  type        = string
  description = "project_name"
}

# Virtual Network CIDR
variable "vnet" {
  type        = list(string)
  description = "Virtual Network CIDR"
}

# subnet CIDRs
variable "aks_subnet" {
  type        = list(string)
  description = "Subnet CIDRs"
}

# subnet CIDRs
variable "pvt_subnet" {
  type        = list(string)
  description = "Subnet CIDRs"
}

# subnet CIDRs
variable "redis_subnet" {
  type        = list(string)
  description = "Subnet CIDRs"
}

# environment
variable "environment" {
  type        = string
  description = "Environment"
  validation {
    condition     = contains(["des", "tqs", "prd"], var.environment)
    error_message = "Por favor escolha entre des, tqs ou prd"
  }
}

#variable "aks_name"{
#  type        = string
#  description = "AKS Name"
#}

# max node count 
variable "aks_max_node_count" {
  type        = number
  description = "Maximun node count for worker node"
}

# min node count 
variable "aks_min_node_count" {
  type        = number
  description = "Minimum node count for worker node"
}

# size of worker node
variable "aks_node_vm_size" {
  type        = string
  description = "Size of worker node"
}

variable "aks_version" {
  type        = string
  description = "Version of the AKS"
}

variable "aks_service_cidr" {
  type        = string
  description = "Aks Service CIDRs"
}

variable "aks_dns_service_ip" {
  type        = string
  description = "Aks DNS Service Ip"
}

variable "client_id" {
  type        = string
  description = "Client ID for Azure"
}

variable "client_certificate_path" {
  type        = string
  description = "Path to the client certificate"
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID for Azure"
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID for Azure"
}


variable "redis_capacity" {
  type        = number
  description = "The size of the Redis cache"
}

variable "redis_family" {
  type        = string
  description = "The family of the SKU to use"
}

variable "redis_sku_name" {
  type        = string
  description = "The SKU of Redis cache to use"
}

variable "redis_enable_non_ssl_port" {
  type        = bool
  description = "Specifies whether the non-ssl Redis server port (6379) is enabled"

}

variable "redis_maxmemory_policy" {
  type        = string
  description = "The eviction policy for the Redis cache"

}

variable "redis_public_network_access" {
  description = " Whether or not public network access is allowed for this Redis Cache. true means this resource could be accessed by both public and private endpoint. false means only private endpoint access is allowed. Defaults to true."
  type        = bool
}

variable "redis_enable_authentication" {
  description = " (Optional) If set to false, the Redis instance will be accessible without authentication. Defaults to true."
  type        = bool
}

// ==========================  azure event hubs variables =========================
variable "kafka_eh_sku" {
  description = "(Required) Defines which tier to use. Valid options are Basic, Standard, and Premium. Please note that setting this field to Premium will force the creation of a new resource."
  type        = string
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.kafka_eh_sku)
    error_message = "The sku of the event hub is invalid."
  }
}
variable "kafka_eh_capacity" {
  description = "(Optional) Specifies the Capacity / Throughput Units for a Standard SKU namespace. Default capacity has a maximum of 2, but can be increased in blocks of 2 on a committed purchase basis."
  type        = number
}
variable "kafka_eh_partition_count" {
  description = "(Optional) Specifies the  number of partitions for a Kafka topic."
  type        = number
}
variable "kafka_eh_message_retention" {
  description = "(Optional) Specifies the  number of message_retention "
  type        = number
}

variable "kafka_eh_topics" {
  description = "(Optional) An array of strings that indicates values of kafka topics."
  type        = list(string)
}



// ========================== storage account variables ==========================
variable "storage_account_kind" {
  description = "(Optional) Specifies the account kind of the storage account"
  type        = string

  validation {
    condition     = contains(["Storage", "StorageV2", "BlobStorage", "BlockBlobStorage", "FileStorage"], var.storage_account_kind)
    error_message = "The account kind of the storage account is invalid."
  }
}
variable "storage_access_tier" {
  description = "(Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
  type        = string

  validation {
    condition     = contains(["Hot", "Cool"], var.storage_access_tier)
    error_message = "The access tier of the storage account is invalid."
  }
}
variable "storage_account_tier" {
  description = "(Optional) Specifies the account tier of the storage account"
  type        = string

  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "The account tier of the storage account is invalid."
  }
}
variable "storage_allow_blob_public_access" {
  description = "(Optional) Specifies the public access type for blob storage"
  type        = bool
}
variable "storage_replication_type" {
  description = "(Optional) Specifies the replication type of the storage account"
  type        = string

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_replication_type)
    error_message = "The replication type of the storage account is invalid."
  }
}

variable "storage_default_action" {
  description = "Allow or disallow public access to all blobs or containers in the storage accounts. The default interpretation is true for this property."
  type        = string
}

variable "storage_container_name" {
  description = " (Required) The name of the Container within the Blob Storage Account where kafka messages should be captured"
  type        = string
}
variable "storage_file_share_name" {
  description = " (Required) The name of the File Share within the Storage Account where Files should be stored"
  type        = string

}

variable "storage_file_share_quota" {
  description = " (Required) The maximum size of the share, in gigabytes."
  type        = number
}

variable "storage_container_access_type" {
  description = "(Optional) The Access Level configured for this Container. Possible values are blob, container or private. Defaults to private."
  type        = string

}

// ========================== log analytics variables ==========================

variable "log_analytics_workspace_sku" {
  description = "(Optional) Specifies the sku of the log analytics workspace"
  type        = string
  validation {
    condition     = contains(["Free", "Standalone", "PerNode", "PerGB2018"], var.log_analytics_workspace_sku)
    error_message = "The log analytics sku is incorrect."
  }
}

variable "log_anatytics_workspaces" {
  description = "A map of workspaces and their associated solutions. 1) Retention in days: Possible values are either 7 (Free Tier only) or range between 30 and 730."
  type = map(object({
    #service_name      = string
    retention_days = number
    solution_name  = string
    solution_plan_map = map(object({
      product   = string
      publisher = string
    }))
  }))
}

variable "log_analytics" {
  description = "Map of log_analytics per resourcegroup to create"
  type        = map(string)
}

// ========================== log analytics variables for aks ==========================


variable "aks_log_data_collection_interval" {
  type    = string
  default = "1m"
}

variable "aks_log_namespace_filtering_mode_for_data_collection" {
  type    = string
  default = "Off"
}

variable "aks_log_namespaces_for_data_collection" {
  type    = list(string)
  default = ["kube-system", "gatekeeper-system", "azure-arc"]
}

variable "aks_log_enableContainerLogV2" {
  type    = bool
  default = true
}

variable "aks_log_streams" {
  type    = list(string)
  default = ["Microsoft-ContainerLog", "Microsoft-ContainerLogV2", "Microsoft-KubeEvents", "Microsoft-KubePodInventory", "Microsoft-KubeNodeInventory", "Microsoft-KubePVInventory", "Microsoft-KubeServices", "Microsoft-KubeMonAgentEvents", "Microsoft-InsightsMetrics", "Microsoft-ContainerInventory", "Microsoft-ContainerNodeInventory", "Microsoft-Perf"]
}