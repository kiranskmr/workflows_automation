terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = "0.11.0"
    }
    databricks = {
      source = "databricks/databricks"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azuredevops" {
  # Configuration options
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

# Use Databricks CLI authentication.
provider "databricks" {
}

# Retrieve information about the current user.
data "databricks_current_user" "me" {}
