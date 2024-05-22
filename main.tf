module "rg" {
  source       = "./modules/resourcegroup"
  for_each     = var.resource_groups
  location     = var.region
  environment  = var.environment
  proj_name    = var.project_name
  service_name = each.value
}


# creating virtual network
module "vnet" {
  source        = "./modules/vnet"
  location      = var.region
  address_space = var.vnet
  environment   = var.environment
  proj_name     = var.project_name
  rg_name       = module.rg["vnet"].rg_name
}

# creating subnet for aks
module "subnetaks" {
  source                = "./modules/subnet"
  subnet_name           = "aks"
  rg_name               = module.rg["vnet"].rg_name
  vnet_name             = module.vnet.vnet_name
  subnet_address_prefix = var.aks_subnet
  environment           = var.environment
  proj_name             = var.project_name
  location              = var.region
}



module "loganalytics" {
  source          = "./modules/loganalytics"
  for_each        = var.log_analytics
  rg_name         = module.rg["${each.value}"].rg_name
  environment     = var.environment
  proj_name       = var.project_name
  location        = var.region
  workspace_sku   = var.log_analytics_workspace_sku
  workspaces      = { 
    (each.value)  = var.log_anatytics_workspaces["${each.value}"]
  }
}



module "redis" {
  source                    = "./modules/redis"
  location                  = var.region
  proj_name                 = var.project_name
  rg_name                   = module.rg["resources"].rg_name
  capacity                  = var.redis_capacity
  family                    = var.redis_family
  sku_name                  = var.redis_sku_name
  maxmemory_policy          = var.redis_maxmemory_policy
  environment               = var.environment
  public_network_access     = var.redis_public_network_access
  enable_authentication     = var.redis_enable_authentication
  rg_id                     = module.rg["resources"].rg_id
  aks_identity_principal_id = module.aks.user_assigned_identity_principal_id
  workspace_id              = module.loganalytics["resources"].log_analytics_workspace_id["resources"]
}



module "eventhub_namespace" {
  source                    = "./modules/eventhubnamespace"
  location                  = var.region
  proj_name                 = var.project_name
  rg_name                   = module.rg["resources"].rg_name
  sku_name                  = var.kafka_eh_sku
  capacity                  = var.kafka_eh_capacity
  environment               = var.environment
  workspace_id              = module.loganalytics["resources"].log_analytics_workspace_id["resources"]
  rg_id                     = module.rg["resources"].rg_id
  aks_identity_principal_id = module.aks.user_assigned_identity_principal_id
}

module "eventhub_topics" {
  source            = "./modules/eventhub"
  for_each          = toset(var.kafka_eh_topics)
  service_name      = each.key
  location          = var.region
  proj_name         = var.project_name
  partition_count   = var.kafka_eh_partition_count
  message_retention = var.kafka_eh_message_retention
  rg_name           = module.rg["resources"].rg_name
  eh_ns_name        = module.eventhub_namespace.eventhub_namespace_name
  environment       = var.environment
}

module "storageaccount" {
  source                    = "./modules/storageaccount"
  location                  = var.region
  proj_name                 = var.project_name
  environment               = var.environment
  rg_name                   = module.rg["resources"].rg_name
  rg_id                     = module.rg["resources"].rg_id
  aks_identity_principal_id = module.aks.user_assigned_identity_principal_id
  access_tier               = var.storage_access_tier
  account_kind              = var.storage_account_kind
  replication_type          = var.storage_replication_type
  account_tier              = var.storage_account_tier
  allow_blob_public_access  = var.storage_allow_blob_public_access
  container_name            = var.storage_container_name
  container_access_type     = var.storage_container_access_type
  file_share_name           = var.storage_file_share_name
  file_share_quota          = var.storage_file_share_quota
  default_action            = var.storage_default_action
  workspace_id              = module.loganalytics["resources"].log_analytics_workspace_id["resources"]
}




# creating AKS
module "aks" {
  source                                        = "./modules/aks"
  rg_name                                       = module.rg["aks"].rg_name
  rg_id                                         = module.rg["aks"].rg_id
  location                                      = var.region
  proj_name                                     = var.project_name
  cluster_version                               = var.aks_version
  service_cidr                                  = var.aks_service_cidr
  dns_service_ip                                = var.aks_dns_service_ip
  environment                                   = var.environment
  max_count                                     = var.aks_max_node_count
  min_count                                     = var.aks_min_node_count
  subnetaks_id                                  = module.subnetaks.public_subnet_id
  node_vm_size                                  = var.aks_node_vm_size
  workspace_id                                  = module.loganalytics["aks"].log_analytics_workspace_id["aks"]
  streams                                       = var.aks_log_streams
  data_collection_interval                      = var.aks_log_data_collection_interval  
  namespace_filtering_mode_for_data_collection  = var.aks_log_namespace_filtering_mode_for_data_collection
  namespaces_for_data_collection                = var.aks_log_namespaces_for_data_collection     
  enableContainerLogV2                          = var.aks_log_enableContainerLogV2
}


