terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-webapp-demo"
  location = "East US"
}

resource "azurerm_service_plan" "plan" {
  name                = "webapp-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "secure_app" {
  name                = "secure-webapp-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  public_network_access_enabled = true
  https_only                    = true

  identity {
    type = "SystemAssigned"
  }

  client_certificate_enabled = true

  site_config {
    http2_enabled = true
    ftps_state    = "FtpsOnly"

    application_stack {
      php_version = "8.2"
    }
  }

  auth_settings {
    enabled                       = true
    unauthenticated_client_action = "RedirectToLoginPage"

    azure_active_directory {
      client_id = "example-client-id"
    }
  }
}