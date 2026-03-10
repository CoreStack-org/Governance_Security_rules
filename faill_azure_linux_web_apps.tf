resource "azurerm_linux_web_app" "linux_fail" {
  name                = "linux-webapp-fail-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  https_only                    = false
  public_network_access_enabled = true
  client_certificate_enabled    = false

  site_config {
    http2_enabled = false
    ftps_state    = "AllAllowed"

    application_stack {
      php_version    = "5.6"
      dotnet_version = "3.1"
    }
  }
}
