terraform{
    required_version = ">= 1.5.0"
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

resource "azurerm_resource_group" "rg1" {
    name     = "rg-terraform"
    location = "westeurope"

    tags = {
        environment = "Lab"
        Project     = "SC-500"
        Module      = "Foundations"
    }
}

