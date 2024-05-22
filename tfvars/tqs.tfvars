####### Basic Info ###############

project_name        = "siada"
region              = "brazilsouth"
environment         = "tqs"
resource_groups     = {
    aks       = "aks"
    resources = "resources"
    vnet      = "vnet"
  }


########### Network #################
vnet                = ["10.0.0.0/21"] #2048
aks_subnet          = ["10.0.0.0/23"] #512
pvt_subnet          = ["10.0.2.0/25"] #128
redis_subnet        = ["10.0.2.128/28"] #16
#XXX_subnet              = ["10.0.2.128/25"] #128


########## Log Analytics ############

log_analytics_workspace_sku =  "PerGB2018"

log_analytics     = {
    aks       = "aks"
    resources = "resources"
  }

log_anatytics_workspaces = {
  aks = {
    retention_days = 30
    solution_name = "ContainerInsights"
    solution_plan_map = {
      solution_plan1 = {
        product = "OMSGallery/ContainerInsights"
        publisher = "Microsoft"
      }
    }
  }
  resources = {
    retention_days = 60
    solution_name = ""
    solution_plan_map = {
      solution_plan1 = {
        product = ""
        publisher = ""
      }
    }
  }
}

########### REDIS ###############
redis_capacity                      =  1
redis_family                        = "C"
redis_sku_name                      = "Basic"
redis_enable_non_ssl_port           = true
redis_maxmemory_policy              = "allkeys-lru"
redis_public_network_access         = true
redis_enable_authentication         = true


######## KAFKA EVENT HUB ###########
kafka_eh_sku                        = "Standard"
kafka_eh_capacity                   = 1
kafka_eh_partition_count            = 2
kafka_eh_message_retention          = 1
kafka_eh_topics                     = [ "antifraude" , "processamento" ]



######## Storage ACCOUNT ###########
storage_access_tier                       = "Hot"
storage_account_kind                      = "StorageV2"
storage_replication_type                  = "LRS"
storage_account_tier                      = "Standard"
storage_allow_blob_public_access          = true
storage_container_name                    = "antifraudreports"
storage_container_access_type             = "blob"
storage_file_share_name                   = "fs-antifraudreports"
storage_file_share_quota                  = "10"
storage_default_action                    = "Allow"


############ AKS ####################
aks_service_cidr    = "10.0.3.0/24"
aks_dns_service_ip  = "10.0.3.10"
aks_version         = "1.28.9"
aks_max_node_count      = 2
aks_min_node_count      = 1
aks_node_vm_size        = "Standard_D2ds_v4"


aks_log_data_collection_interval                      = "1m"
aks_log_namespace_filtering_mode_for_data_collection  = "Off"
aks_log_namespaces_for_data_collection                = ["kube-system","gatekeeper-system"]
aks_log_enableContainerLogV2                          = true
aks_log_streams                                       = ["Microsoft-ContainerLog", "Microsoft-ContainerLogV2", "Microsoft-KubeEvents", "Microsoft-KubePodInventory", "Microsoft-KubeNodeInventory", "Microsoft-KubePVInventory","Microsoft-KubeServices", "Microsoft-KubeMonAgentEvents", "Microsoft-InsightsMetrics", "Microsoft-ContainerInventory",  "Microsoft-ContainerNodeInventory", "Microsoft-Perf"]

