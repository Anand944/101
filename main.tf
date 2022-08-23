# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Providergi
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "devrm" {
  name     = var.resourceGroupName
  location = var.location
  tags = var.tags
}
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space 
  location            = azurerm_resource_group.devrm.location
  resource_group_name = azurerm_resource_group.devrm.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_names
  resource_group_name  = azurerm_resource_group.devrm.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.devrm.location
  resource_group_name = azurerm_resource_group.devrm.name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.devrm.name
  location            = azurerm_resource_group.devrm.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}