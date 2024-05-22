resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "./secrets/private_key.pem"
}

resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "./secrets/public_key.pub"
}

data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

# creating azure container registry 
resource "azurerm_container_registry" "acr" {
  name                = "acr${var.proj_name}${var.environment}"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
  depends_on          = [var.rg_name]
}


resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "aks_identity"
  resource_group_name = var.rg_name
  location            = var.location
}

# creating AKS cluster
resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                      = "aks-${var.proj_name}-${var.environment}"
  location                  = var.location
  resource_group_name       = var.rg_name
  dns_prefix                = "dns-aks-${var.proj_name}-${var.environment}"
  node_resource_group       = "rg-${var.proj_name}-aksnodes-${var.environment}"
  sku_tier                  = var.environment == "prd" ? "Standard" : "Free"
  automatic_channel_upgrade = "stable"
  kubernetes_version        = var.cluster_version
  depends_on                = [var.rg_name,var.subnetaks_id]
  azure_policy_enabled      = true

  #oidc_issuer_enabled       = true
  #workload_identity_enabled = true



  default_node_pool {
    name                = "sysnodepool"
    vm_size             = var.node_vm_size
    zones               = [1]
    enable_auto_scaling = true
    node_count          = 1
    max_count           = var.max_count
    min_count           = var.min_count
    vnet_subnet_id      = var.subnetaks_id
    os_disk_size_gb     = 30
    type                = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "${var.environment}"
      "nodepoolos"    = "linux"
      "role"          = "agent"
    }

    upgrade_settings {
      max_surge = "10%"
    }
    tags = {
      "nodepool-type" = "system"
      "environment"   = "${var.environment}"
      "nodepoolos"    = "linux"
    }
  }
/*
  identity {
    type = "SystemAssigned"    
  }
*/
  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]    
  }

  oms_agent {
    log_analytics_workspace_id = var.workspace_id
    msi_auth_for_monitoring_enabled = true
  }

  linux_profile {
    admin_username = "aksadmin"
    ssh_key {
      key_data = tls_private_key.ssh_key.public_key_openssh
    }
  }

  network_profile {
    network_plugin    = "azure"
    dns_service_ip = var.dns_service_ip
    service_cidr   = var.service_cidr
    load_balancer_sku = "standard"
  }

  auto_scaler_profile {
    balance_similar_node_groups = true
  }

  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "wrk_nodepool" {
  name                  = "wrknodepool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks-cluster.id
  vm_size               = var.node_vm_size
  zones                 = [1]
  enable_auto_scaling   = true
  max_count             = var.max_count
  min_count             = var.min_count
  vnet_subnet_id        = var.subnetaks_id
  os_disk_size_gb       = 30
  
  priority        = var.environment == "des" ? "Spot" : "Regular"
  eviction_policy = var.environment == "des" ? "Deallocate" : null


  node_labels = {
    "nodepool-type" = "user"
    "environment"   = var.environment
    "nodepoolos"    = "linux"
    "role"          = var.environment == "des" ? "spot" : null
    "kubernetes.azure.com/scalesetpriority" = var.environment == "des" ? "spot" : null
  }

  node_taints = var.environment == "des" ? ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule","spot:NoSchedule"] : []

  tags = {
    "nodepool-type" = "user"
    "environment"   = var.environment
    "nodepoolos"    = "linux"
  }

  lifecycle {
    ignore_changes = [node_count]
  }
}

# kubeconfig file
resource "local_file" "kubeconfig" {
  depends_on = [azurerm_kubernetes_cluster.aks-cluster]
  filename   = "./secrets/kubeconfig"
  content    = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
}

resource "local_file" "kubeconfigyaml" {
  depends_on = [azurerm_kubernetes_cluster.aks-cluster]
  content  = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
  filename = "./secrets/kubeconfig.yaml"
}

# role assignment for AKS to pull images from ACR
resource "azurerm_role_assignment" "role_acr_pull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_user_assigned_identity.aks_identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "cluster_admin" {
  scope                            = azurerm_kubernetes_cluster.aks-cluster.id
  role_definition_name             = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id                     = azurerm_user_assigned_identity.aks_identity.principal_id
  skip_service_principal_aad_check = true
}



resource "azurerm_monitor_data_collection_rule" "dcr" {
  name                = "MSCI-${var.location}-${azurerm_kubernetes_cluster.aks-cluster.name}"
  resource_group_name = var.rg_name
  location            = var.location

  destinations {
    log_analytics {
      workspace_resource_id = var.workspace_id
      name                  = "ciworkspace"
    }
  }

  data_flow {
    streams      = var.streams
    destinations = ["ciworkspace"]
  }

  data_sources {
    extension {
      streams            = var.streams
      extension_name     = "ContainerInsights"
      extension_json     = jsonencode({
        "dataCollectionSettings" : {
            "interval": var.data_collection_interval,
            "namespaceFilteringMode": var.namespace_filtering_mode_for_data_collection,
            "namespaces": var.namespaces_for_data_collection
            "enableContainerLogV2": var.enableContainerLogV2
        }
      })
      name               = "ContainerInsightsExtension"
    }
  }

  description = "DCR for Azure Monitor Container Insights"
}

resource "azurerm_monitor_data_collection_rule_association" "dcra" {
  name                        = "ContainerInsightsExtension"
  target_resource_id          = azurerm_kubernetes_cluster.aks-cluster.id
  data_collection_rule_id     = azurerm_monitor_data_collection_rule.dcr.id
  description                 = "Association of container insights data collection rule. Deleting this association will break the data collection for this AKS Cluster."
}



resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  namespace  = "ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.replicaCount"
    value = 2
  }

  set {
    name  = "controller.nodeSelector.kubernetes\\.io/os"
    value = "linux"
  }

  set {
    name  = "controller.admissionWebhooks.patch.nodeSelector.kubernetes\\.io/os"
    value = "linux"
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  depends_on = [azurerm_kubernetes_cluster.aks-cluster, local_file.kubeconfig,local_file.kubeconfigyaml]
}