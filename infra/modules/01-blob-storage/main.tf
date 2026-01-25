# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "raw_and_curated_storage_account" {
  name                     = "tfuniversityrankings"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "raw_data_container" {
  name                  = "raw"
  storage_account_id    = azurerm_storage_account.raw_and_curated_storage_account.id
  container_access_type = "container"
}

resource "azurerm_storage_container" "curated_data_container" {
  name                  = "curated"
  storage_account_id    = azurerm_storage_account.raw_and_curated_storage_account.id
  container_access_type = "container"
}

