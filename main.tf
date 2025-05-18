provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# App Service Plan using CAF module
module "app_service_plan" {
  source              = "github.com/aztfmod/terraform-azurerm-caf//modules/app_service_plan?ref=5.7.14"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = var.app_service_plan_name
  sku_name            = var.app_service_plan_sku
}

# Storage Account using CAF module
module "storage_account" {
  source                    = "github.com/aztfmod/terraform-azurerm-caf//modules/storage_account?ref=5.7.14"
  resource_group_name       = azurerm_resource_group.main.name
  location                  = azurerm_resource_group.main.location
  name                      = var.storage_account_name
  account_tier              = var.storage_account_tier
  account_replication_type  = var.storage_account_replication
}

# Log Analytics Workspace using CAF module
module "log_analytics" {
  source              = "github.com/aztfmod/terraform-azurerm-caf//modules/log_analytics_workspace?ref=5.7.14"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = var.log_analytics_workspace_name
  sku                 = var.log_analytics_workspace_sku
}

# Function App using CAF module
module "function_app" {
  source                      = "github.com/aztfmod/terraform-azurerm-caf//modules/function_app?ref=4.22.0"
  resource_group_name         = azurerm_resource_group.main.name
  location                    = azurerm_resource_group.main.location
  name                        = var.function_app_name
  app_service_plan_id         = module.app_service_plan.id
  storage_account_name        = module.storage_account.name
  storage_account_access_key  = module.storage_account.primary_access_key
  application_insights_key    = module.log_analytics.instrumentation_key
  os_type                     = "linux"
  version                     = "~> 4.0"
}
