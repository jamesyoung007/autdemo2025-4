variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region for resources."
  type        = string
  default     = "eastus"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan."
  type        = string
}

variable "app_service_plan_sku" {
  description = "SKU for the App Service Plan."
  type        = string
  default     = "P1v2"
}

variable "storage_account_name" {
  description = "Name of the Storage Account."
  type        = string
}

variable "storage_account_tier" {
  description = "Tier for the Storage Account."
  type        = string
  default     = "Standard"
}

variable "storage_account_replication" {
  description = "Replication type for the Storage Account."
  type        = string
  default     = "LRS"
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace."
  type        = string
}

variable "log_analytics_workspace_sku" {
  description = "SKU for the Log Analytics Workspace."
  type        = string
  default     = "PerGB2018"
}

variable "function_app_name" {
  description = "Name of the Function App."
  type        = string
}
