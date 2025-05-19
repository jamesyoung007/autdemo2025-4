variable "resource_prefix" {
  description = "Prefix used for all resource names"
  type        = string
  default     = "autdemo4"
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "East US"
}

variable "storage_account_name" {
  description = "Globally unique storage account name"
  type        = string
  default     = "autdemo4storage"
}

variable "log_analytics_name" {
  description = "Log Analytics Workspace name"
  type        = string
  default     = "autdemo4-law"
}

variable "app_service_plan_name" {
  description = "App Service Plan name"
  type        = string
  default     = "autdemo4-plan"
}

variable "function_app_name" {
  description = "Function App name"
  type        = string
  default     = "autdemo4-func"
}
