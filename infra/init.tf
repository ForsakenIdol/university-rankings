# Terraform and Azure provider block declarations will go in this file.

terraform {
    required_version = ">= 1.14.0"

    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = ">= 4.57.0"
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
  subscription_id                 = "0a0d7689-300a-42af-a654-63deb6634122"
  resource_provider_registrations = "none"
  features {}
}
