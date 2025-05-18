provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias = "vhub"
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "caf" {
  source  = "aztfmod/caf/azurerm"
  version = "5.7.14"
  providers = {
    azurerm = azurerm
    azurerm.vhub = azurerm.vhub
  }

  # Resource group context
  resource_groups = {
    demo = {
      name     = var.resource_group_name
      location = var.location
    }
  }

  # App Service Plan
  app_service_plans = {
    demo_plan = {
      name                = var.app_service_plan_name
      resource_group_key  = "demo"
      location            = var.location
      sku_name            = var.app_service_plan_sku
    }
  }

  # Storage Account
  storage_accounts = {
    demo_storage = {
      name                     = var.storage_account_name
      resource_group_key       = "demo"
      location                 = var.location
      account_tier             = var.storage_account_tier
      account_replication_type = var.storage_account_replication
    }
  }

  # Log Analytics Workspace
  log_analytics_workspaces = {
    demo_law = {
      name               = var.log_analytics_workspace_name
      resource_group_key = "demo"
      location           = var.location
      sku                = var.log_analytics_workspace_sku
    }
  }

  # Function App
  function_apps = {
    demo_func = {
      name                       = var.function_app_name
      resource_group_key         = "demo"
      location                   = var.location
      app_service_plan_key       = "demo_plan"
      storage_account_key        = "demo_storage"
      log_analytics_workspace_key = "demo_law"
      os_type                    = "linux"
      version                    = "~4"
    }
  }
}
