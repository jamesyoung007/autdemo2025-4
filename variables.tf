variable "resource_group_name" {
  type        = string
  default     = "AUT-2025-demo_4"
}

variable "location" {
  description = "Azure region for resources."
  type        = string
  default     = "eastus"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan."
  type        = string
  default = "jamesappserviceplan"
}

variable "app_service_plan_sku" {
  type        = string
  default     = "Y1"
}

variable "storage_account_name" {
  description = "Name of the Storage Account."
  type        = string
  default = "jamestestsa"
}

variable "storage_account_tier" {
  type        = string
  default     = "Standard"
}

variable "storage_account_replication" {
  type        = string
  default     = "LRS"
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace."
  type        = string
  default = "jamesloganalyticsworkspacename"
}

variable "log_analytics_workspace_sku" {
  type        = string
  default     = "PerGB2018"
}

variable "function_app_name" {
  description = "Name of the Function App."
  type        = string
  default = "jamesfunctionappname"
}
