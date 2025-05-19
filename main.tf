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
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_prefix}-rg"
  location = var.location
}

module "storage_account" {
  source  = "aztfmod/caf/azurerm//modules/storage_account"
  version = "5.6.7"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  storage_accounts = {
    "main" = {
      name                       = var.storage_account_name
      account_tier               = "Standard"
      account_replication_type   = "LRS"
      enable_https_traffic_only  = true
    }
  }
}

module "log_analytics" {
  source  = "aztfmod/caf/azurerm//modules/monitoring"
  version = "5.6.7"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  log_analytics = {
    "main" = {
      name              = var.log_analytics_name
      retention_in_days = 30
      sku               = "PerGB2018"
    }
  }
}

module "app_service_plan" {
  source  = "aztfmod/caf/azurerm//modules/app_service_plans"
  version = "5.6.7"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  app_service_plans = {
    "main" = {
      name              = var.app_service_plan_name
      kind              = "FunctionApp"
      sku_tier          = "Dynamic"
      sku_size          = "Y1"
      per_site_scaling  = false
      is_xenon          = false
    }
  }
}

module "function_app" {
  source  = "aztfmod/caf/azurerm//modules/function_app"
  version = "5.6.7"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  function_apps = {
    "main" = {
      name                      = var.function_app_name
      app_service_plan_id       = module.app_service_plan.app_service_plans["main"].id
      storage_account_name      = module.storage_account.storage_accounts["main"].name
      storage_account_key       = module.storage_account.storage_accounts["main"].primary_access_key
      os_type                   = "linux"
      runtime_stack             = "python"
      runtime_version           = "3.11"
      use_32_bit_worker_process = false
      application_settings = {
        FUNCTIONS_WORKER_RUNTIME          = "python"
        WEBSITE_RUN_FROM_PACKAGE          = "1"
        LOG_ANALYTICS_WORKSPACE_ID        = module.log_analytics.log_analytics["main"].id
      }
    }
  }
}
