provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-network"
  location = "East US"
}

resource "azurerm_network_security_group" "bad_nsg" {
  name                = "bad-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-UDP-Internet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "999"
    destination_port_range     = "53"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }
}