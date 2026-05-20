resource "azurerm_linux_web_app" "linux_pass" {
  name                = "linux-webapp-pass-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  https_only                     = true
  public_network_access_enabled  = false
  client_certificate_enabled     = true
  client_certificate_exclusion_paths = ""

  identity {
    type = "SystemAssigned"
  }

  site_config {
    http2_enabled = true
    ftps_state    = "FtpsOnly"

    application_stack {
      php_version    = "8.2"
      dotnet_version = "6.0"
    }
  }
}
