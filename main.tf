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
  source  = "github.com/aztfmod/terraform-azurerm-caf.git//modules/storage_account?ref=5.6.7"

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
  source  = "github.com/aztfmod/terraform-azurerm-caf.git//modules/monitoring?ref=5.6.7"

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
  source  = "github.com/aztfmod/terraform-azurerm-caf.git//modules/app_service_plans?ref=5.6.7"

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
  source  = "github.com/aztfmod/terraform-azurerm-caf.git//modules/function_app?ref=5.6.7"

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

module "caf_function_app" {
  source  = "github.com/aztfmod/terraform-azurerm-caf.git//modules/webapps/function_app?ref=5.6.7"
  resource_group_name = var.resource_group_name
  location            = var.location
  function_apps = {
    "main" = {
      name                      = "autdemo4-caf-functionapp"
      service_plan_id           = module.app_service_plan.app_service_plans["main"].id
      storage_account_name      = module.storage_account.storage_accounts["main"].name
      storage_account_key       = module.storage_account.storage_accounts["main"].primary_access_key
      os_type                   = "linux"
      runtime_stack             = "node"
      runtime_version           = "18"
      use_32_bit_worker_process = false
      app_settings = {
        FUNCTIONS_WORKER_RUNTIME   = "node"
        WEBSITE_RUN_FROM_PACKAGE   = "1"
        LOG_ANALYTICS_WORKSPACE_ID = module.log_analytics.log_analytics["main"].id
      }
    }
  }
}

module "webapp" {
  source  = "github.com/aztfmod/terraform-azurerm-caf.git//modules/webapps/appservice?ref=5.6.7"
  resource_group_name = var.resource_group_name
  location            = var.location
  appservices = {
    "main" = {
      name                = "autdemo4-webapp"
      service_plan_id     = module.app_service_plan.app_service_plans["main"].id
      https_only          = true
      client_affinity_enabled = false
      site_config = {
        linux_fx_version = "NODE|18-lts"
      }
      app_settings = {
        APPINSIGHTS_INSTRUMENTATIONKEY = module.log_analytics.log_analytics["main"].instrumentation_key
      }
    }
  }
}


