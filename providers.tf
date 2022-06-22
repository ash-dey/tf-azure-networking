# Define providers to use - can use mutiple providers in the same code
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.10.0"
    }
  }

  required_version = ">= 1.2.0"

  # define terraform cloud targets e.g. organization and workspace
  cloud {}
}

# Define credential details for the provider
provider "azurerm" {
  features {}
}

