variable "resource_group_name" {
  type        = string
  description = "Resource Group name for AKS"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"
  default     = "West Europe"
}

variable "acr_name" {
  type        = string
  description = "Azure Container Registry name"
}

variable "aks_name" {
  type        = string
  description = "Kubernetes Cluster name"
}