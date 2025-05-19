terraform {
  backend "azurerm" {
    resource_group_name   = "tfstaterg"
    storage_account_name  = "autdemotfstate"
    container_name        = "tfstate"
    key                   = "terraform.tfstate_4"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "57480482-27fc-46a6-8643-ee45484365ec"
  resource_provider_registrations = "none"
}

variable "location" {
  type    = string
  default = "Australia East"
}

variable "resource_group_name" {
  type    = string
  default = "AUT-2025-demo_4"
}

module "storage_account" {
  source  = "aztfmod/caf/azurerm//modules/storage_account"
  version = "5.6.7"

  resource_group_name = var.resource_group_name
  location            = var.location

  storage_accounts = {
    "main" = {
      name                     = "autdemo4storage1234"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      enable_https_traffic_only = true
    }
  }
}

module "log_analytics" {
  source  = "aztfmod/caf/azurerm//modules/monitoring"
  version = "5.6.7"

  resource_group_name = var.resource_group_name
  location            = var.location

  log_analytics = {
    "main" = {
      name              = "autdemo4-law"
      retention_in_days = 30
      sku               = "PerGB2018"
    }
  }
}

module "app_service_plan" {
  source  = "aztfmod/caf/azurerm//modules/app_service_plans"
  version = "5.6.7"

  resource_group_name = var.resource_group_name
  location            = var.location

  app_service_plans = {
    "main" = {
      name             = "autdemo4-function-plan"
      kind             = "FunctionApp"
      sku_tier         = "Dynamic"
      sku_size         = "Y1"
      per_site_scaling = false
      is_xenon         = false
    }
  }
}

module "function_app" {
  source  = "aztfmod/caf/azurerm//modules/function_app"
  version = "5.6.7"

  resource_group_name = var.resource_group_name
  location            = var.location

  function_apps = {
    "main" = {
      name                      = "autdemo4-functionapp1234"
      app_service_plan_id       = module.app_service_plan.app_service_plans["main"].id
      storage_account_name      = module.storage_account.storage_accounts["main"].name
      storage_account_key       = module.storage_account.storage_accounts["main"].primary_access_key
      os_type                   = "linux"
      runtime_stack             = "node"
      runtime_version           = "18"
      use_32_bit_worker_process = false
      application_settings = {
        FUNCTIONS_WORKER_RUNTIME   = "node"
        WEBSITE_RUN_FROM_PACKAGE   = "1"
        LOG_ANALYTICS_WORKSPACE_ID = module.log_analytics.log_analytics["main"].id
      }
    }
  }
}

module "function_diagnostics" {
  source  = "aztfmod/caf/azurerm//modules/monitor_diagnostic_settings"
  version = "5.6.7"

  diagnostic_settings = {
    "function" = {
      name                       = "diag-function"
      target_resource_id         = module.function_app.function_apps["main"].id
      log_analytics_workspace_id = module.log_analytics.log_analytics["main"].id
      enabled_log = [
        {
          category = "FunctionAppLogs"
          retention_policy = {
            enabled = false
          }
        }
      ]
      metric = [
        {
          category = "AllMetrics"
          enabled  = true
          retention_policy = {
            enabled = false
          }
        }
      ]
    }
    "storage" = {
      name                       = "diag-storage"
      target_resource_id         = module.storage_account.storage_accounts["main"].id
      log_analytics_workspace_id = module.log_analytics.log_analytics["main"].id
      metric = [
        {
          category = "Transaction"
          enabled  = true
          retention_policy = {
            enabled = false
          }
        }
      ]
    }
  }
}
