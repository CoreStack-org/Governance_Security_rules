resource "azurerm_resource_group" "rg_network" {
  name     = "rg-network-eastus"
  location = "East US"
}
resource "azurerm_network_watcher" "nw" {
  name                = "NetworkWatcher_eastus"
  location            = azurerm_resource_group.rg_network.location
  resource_group_name = azurerm_resource_group.rg_network.name
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-eastus"
  location            = azurerm_resource_group.rg_network.location
  resource_group_name = azurerm_resource_group.rg_network.name
  address_space       = ["10.0.0.0/16"]
}