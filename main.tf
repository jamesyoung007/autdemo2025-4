terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0"
    }
  }
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

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "storage_account" {
  source  = "github.com/jamesyoung007/autdemo2025-3.git//modules/st?ref=main"

  resource_group_name   = var.resource_group_name
  location              = var.location
  storage_account_name  = "autdemo4storage"
}

module "log_analytics" {
  source  = "github.com/jamesyoung007/autdemo2025-3.git//modules/monitoring?ref=main"

  resource_group_name           = var.resource_group_name
  location                     = var.location
  log_analytics_workspace_name  = "autdemo4-law"
}

module "app_service_plan" {
  source  = "github.com/jamesyoung007/autdemo2025-3.git//modules/app_service_plan?ref=main"

  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_name   = "autdemo4-asp"
  service_plan_sku    = "Y1"
}

module "function_app" {
  source = "github.com/jamesyoung007/autdemo2025-3.git//modules/func?ref=main"

  location                  = var.location
  resource_group_name       = var.resource_group_name
  storage_account_name      = module.storage_account.storage_account_name
  storage_account_access_key = module.storage_account.storage_account_access_key
  function_app_name         = "autdemo4-func"
  service_plan_name         = module.app_service_plan.service_plan_name
  service_plan_id           = module.app_service_plan.service_plan_id
  service_plan_sku          = module.app_service_plan.service_plan_sku
}



