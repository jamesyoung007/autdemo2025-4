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

  client_config   = {}
  global_settings = {}
  base_tags       = false
  resource_group  = {
    name     = var.resource_group_name
    location = var.location
  }
  storage_account = {
    autdemo4storage = {
      name                     = "autdemo4storage"
      account_tier             = "Standard"
      account_replication_type = "LRS"
    }
  }
}



