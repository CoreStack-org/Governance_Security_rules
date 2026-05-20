provider "azurerm" {
  features {}
}

locals {
  first_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+wWK73dCr+jgQOAxNsHAnNNNMEMWOHYEccp6wJm2gotpr9katuF/ZAdou5AaW1C61slRkHRkpRRX9FA9CYBiitZgvCCz+3nWNN7l/Up54Zps/pHWGZLHNJZRYyAB6j5yVLMVHIHriY49d/GZTZVNB8GoJv9Gakwc/fuEZYYl4YDFiGMBP///TzlI4jhiJzjKnEvqPFki5p2ZRJqcbCiF4pJrxUQR/RXqVFQdbRLZgYfJ8xGB878RENq3yQ39d8dVOkq4edbkzwcUmwwwkYVPIoDGsYLaRHnG+To7FvMeyO7xDVQkMKzopTQV8AuKpyvpqu0a9pWOMaiCyDytO7GGN you@me.com"
}

resource "azurerm_resource_group" "example" {
  name     = "vmss-fail-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "vmss-fail-vnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_linux_virtual_machine_scale_set" "example" {
  name                = "vmss-fail"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  sku            = "Standard_F2"
  instances      = 1
  admin_username = "adminuser"

  upgrade_mode = "Manual"

  automatic_os_upgrade_policy {
    enable_automatic_os_upgrade = false
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = local.first_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "22.04.202401010"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic-fail"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.example.id
    }
  }
}