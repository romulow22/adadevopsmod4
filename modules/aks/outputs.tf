# AKS cluster name 
output "kubernetes_cluster_name" {
  value       = azurerm_kubernetes_cluster.aks-cluster.name
  description = "Name of the AKS Cluster"
}

# AKS Cluster ID
output "kubernetes_cluster_id" {
  value       = azurerm_kubernetes_cluster.aks-cluster.id
  description = "ID of the AKS Cluster"
}

# FQDN of nodes
output "kubernetes_cluster_fqdn" {
  value = azurerm_kubernetes_cluster.aks-cluster.fqdn
}

# ACR ID
output "acr_id" {
  value = azurerm_container_registry.acr.id
}

output "user_assigned_identity_client_id" {
  value = azurerm_user_assigned_identity.aks_identity.client_id
}

output "user_assigned_identity_principal_id" {
  value = azurerm_user_assigned_identity.aks_identity.principal_id
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks-cluster.kube_config
}

output "kube_config_raw" {
  value = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
}


output "nginx_ingress_controller_status" {
  description = "The external IP of the NGINX Ingress Controller"
  value       = helm_release.nginx_ingress.status
}

