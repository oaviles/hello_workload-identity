variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location for all resources."
}

variable "resource_group_name" {
  type        = string
  default     = "oa-aks-rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "aks_cluster_name" {
  type        = string
  default     = "oaAKSCluster"
}