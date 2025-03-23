terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "caso_practico_2" {
  name     = var.grupo_de_recursos
  location = var.localizacion
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-cp-2"
  location            = azurerm_resource_group.caso_practico_2.location
  resource_group_name = azurerm_resource_group.caso_practico_2.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-cp-2"
  resource_group_name  = azurerm_resource_group.caso_practico_2.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-cp-2"
  location            = azurerm_resource_group.caso_practico_2.location
  resource_group_name = azurerm_resource_group.caso_practico_2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

resource "azurerm_public_ip" "vm_public_ip" {
  name                = "vm-public-ip-cp2"
  location            = azurerm_resource_group.caso_practico_2.location
  resource_group_name = azurerm_resource_group.caso_practico_2.name
  allocation_method   = "Static"
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-cp-2"
  location            = azurerm_resource_group.caso_practico_2.location
  resource_group_name = azurerm_resource_group.caso_practico_2.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                = "Standard_B2s"

  admin_username      = "josuazure"
  admin_ssh_key {
    username   = "josuazure"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
