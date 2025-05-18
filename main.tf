provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "app_service_plan" {
  source              = "aztfmod/caf/azurerm//modules/app_service_plan"
  version             = "5.7.14"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = var.app_service_plan_name
  sku_name            = var.app_service_plan_sku
}

module "storage_account" {
  source                    = "aztfmod/caf/azurerm//modules/storage_account"
  version                   = "5.7.14"
  resource_group_name       = azurerm_resource_group.main.name
  location                  = azurerm_resource_group.main.location
  name                      = var.storage_account_name
  account_tier              = var.storage_account_tier
  account_replication_type  = var.storage_account_replication
}

module "log_analytics" {
  source              = "aztfmod/caf/azurerm//modules/log_analytics_workspace"
  version             = "5.7.14"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = var.log_analytics_workspace_name
  sku                 = var.log_analytics_workspace_sku
}

module "function_app" {
  source                      = "aztfmod/caf/azurerm//modules/function_app"
  version                     = "5.7.14"
  resource_group_name         = azurerm_resource_group.main.name
  location                    = azurerm_resource_group.main.location
  name                        = var.function_app_name
  app_service_plan_id         = module.app_service_plan.id
  storage_account_name        = module.storage_account.name
  storage_account_access_key  = module.storage_account.primary_access_key
  application_insights_key    = module.log_analytics.instrumentation_key
  os_type                     = "linux"
  version_function            = "~4"
}
