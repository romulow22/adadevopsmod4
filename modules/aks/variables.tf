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

# max node count
variable "max_count" {
  type        = number
  description = "Maximum node count for worker node"
}

# min node count
variable "min_count" {
  type        = number
  description = "Minimum node count for worker node"
}

# subnet ID
variable "subnetaks_id" {
  type        = string
  description = "Subnet ID for worker node"
}

#variable "subnetappgtw_id" {
#  type        = string
#  description = "Subnet ID for appgtw"
#}

# Size of worker nodes
variable "node_vm_size" {
  type        = string
  description = "Worker nodes size"
}

#variable "cluster_sku"{
#  type        = string
#  description = "AKS SKU"
#}

variable "cluster_version"{
  type        = string
  description = "AKS version"
}

variable "service_cidr" {
  type        = string
  description = "Aks Service CIDRs"
}

variable "dns_service_ip" {
  type        = string
  description = "Aks DNS Service Ip"
}

variable "rg_name"{
  type        = string
  description = "resource group name"
}

variable "rg_id"{
  type        = string
  description = "resource group id"
}


variable "workspace_id"{
  type        = string
  description = "workspace_id"
}

variable "data_collection_interval" {
  default = "1m"
}

variable "namespace_filtering_mode_for_data_collection" {
  default = "Off"
}

variable "namespaces_for_data_collection" {
  default = ["kube-system", "gatekeeper-system", "azure-arc"]
}

variable "enableContainerLogV2" {
  default = true
}

variable "streams" {
 default = ["Microsoft-ContainerLog", "Microsoft-ContainerLogV2", "Microsoft-KubeEvents", "Microsoft-KubePodInventory", "Microsoft-KubeNodeInventory", "Microsoft-KubePVInventory","Microsoft-KubeServices", "Microsoft-KubeMonAgentEvents", "Microsoft-InsightsMetrics", "Microsoft-ContainerInventory",  "Microsoft-ContainerNodeInventory", "Microsoft-Perf"]
}