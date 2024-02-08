# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.90.0"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg_afzaal_poc"
    storage_account_name = "sandboxtfstorage01"
    container_name       = "containerinstance"
    key                  = "terraform.tfstate"
  }
}
########################### Data ##############################

data "azurerm_resource_group" "rg" {
  name = "rg_afzaal_poc"
}

########################### Variables ##############################

variable "imagebuild" {
  type        = string
  description = "Latest Image Build"
}

########################### Resources ##############################

resource "azurerm_container_group" "tfcg_test" {
  name                = "weatherapi"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_address_type = "Public"
  dns_name_label  = "virtualeracloud"
  os_type         = "Linux"

  container {
    name   = "weatherapi"
    image  = "binarythistle/weatherapi:${var.imagebuild}"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}