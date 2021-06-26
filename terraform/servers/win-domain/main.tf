terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-state"
    storage_account_name  = "mdterraform"
    container_name        = "demo-state"
    key                   = "servers.tfstate"
  }
}

provider "azurerm" {
  features {}
}

variable "admin_password" {  
  description = "Administrator password"  
  type        = string  
  sensitive   = true
}

resource "azurerm_resource_group" "ad-vms-rg" {
  name     = "ad-vms-rg"
  location = "eastus2"
}

resource "azurerm_virtual_network" "tier-0" {
  name                = "tier-0-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.ad-vms-rg.location
  resource_group_name = azurerm_resource_group.ad-vms-rg.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.ad-vms-rg.name
  virtual_network_name = azurerm_virtual_network.tier-0.name
  address_prefixes     = ["10.0.2.0/24"]
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "servers-nsg"
  location            = azurerm_resource_group.ad-vms-rg.location
  resource_group_name = azurerm_resource_group.ad-vms-rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "142.186.4.19/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "WinRM"
    priority                   = 1011
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5986"
    source_address_prefix      = "142.186.4.19/32"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}


resource "azurerm_subnet_network_security_group_association" "internal" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

resource "azurerm_public_ip" "dc-public" {
  name                = "dc01-public"
  resource_group_name = azurerm_resource_group.ad-vms-rg.name
  location            = azurerm_resource_group.ad-vms-rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "dc-nic" {
  name                = "dc01-nic"
  location            = azurerm_resource_group.ad-vms-rg.location
  resource_group_name = azurerm_resource_group.ad-vms-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id  = azurerm_public_ip.dc-public.id
  }
}

resource "azurerm_windows_virtual_machine" "domain-controller" {
  name                = "ca-dc-01"
  resource_group_name = azurerm_resource_group.ad-vms-rg.name
  location            = azurerm_resource_group.ad-vms-rg.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.dc-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# Sync server
resource "azurerm_public_ip" "sync-public" {
  name                = "sync-public"
  resource_group_name = azurerm_resource_group.ad-vms-rg.name
  location            = azurerm_resource_group.ad-vms-rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}


resource "azurerm_network_interface" "sync-nic" {
  name                = "sync-nic"
  location            = azurerm_resource_group.ad-vms-rg.location
  resource_group_name = azurerm_resource_group.ad-vms-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id  = azurerm_public_ip.sync-public.id
  }
}

resource "azurerm_windows_virtual_machine" "sync" {
  name                = "ca-sync-01"
  resource_group_name = azurerm_resource_group.ad-vms-rg.name
  location            = azurerm_resource_group.ad-vms-rg.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.sync-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}


data "azurerm_public_ip" "dc-ip" {
  name = azurerm_public_ip.dc-public.name
  resource_group_name = azurerm_windows_virtual_machine.domain-controller.resource_group_name
  depends_on = [azurerm_windows_virtual_machine.domain-controller]
}


output "public_ip_address_dc" {
  value = data.azurerm_public_ip.dc-ip.ip_address
}

data "azurerm_public_ip" "sync-ip" {
  name = azurerm_public_ip.sync-public.name
  resource_group_name = azurerm_windows_virtual_machine.sync.resource_group_name
  depends_on = [azurerm_windows_virtual_machine.sync]
}


output "public_ip_address_sync" {
  value = data.azurerm_public_ip.sync-ip.ip_address
}
