terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      # per guidance from Microsoft, this is required to allow for the Key Vault to be deleted without having to wait 90 days 
      # for the soft delete retention period to expire. This is only recommended for development and testing environments, 
      #and should not be used in production environments.
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "current" {}


resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "DevSecOps"
    Project     = "SC-500"
    Module      = "Foundations"
  }
}

# Network Security Group: Principio Zero Trust "Default Deny Inbound"
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-workload-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "DevSecOps"
    Project     = "SC-500"
    Module      = "Foundations"
  }
}

# Rete Virtuale e Subnet applicativa
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-sc500-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet_apps" {
  name                 = "snet-apps"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet_apps.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Key Vault con RBAC per Data Plane e ACL di rete Zero Trust
resource "azurerm_key_vault" "kv" {
  name                       = "kv-sc500-${var.unique_suffix}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  enable_rbac_authorization  = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}
