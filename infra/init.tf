# Terraform and Azure provider block declarations will go in this file.

terraform {
  required_version = ">= 1.14.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.57.0"
    }

    databricks = {
      source = "databricks/databricks"
      version = ">= 1.104.0"
    }
  }

  backend "remote" {
    # The `hostname` parameter will default to "app.terraform.io".
    organization = "forsakenidol-organization-1"

    workspaces {
      # If you specify a workspace that does not exist, it is automatically created in the Terraform Cloud.
      name = "university-rankings"
    }
  }

}

provider "azurerm" {
  subscription_id                 = "69136e63-a1ea-4e45-8d0b-2a3e5196c9cb"
  resource_provider_registrations = "none"
  features {}
}

provider "databricks" {
  host = module.databricks.databricks_workspace_url
  azure_workspace_resource_id = module.databricks.databricks_workspace_id
}

