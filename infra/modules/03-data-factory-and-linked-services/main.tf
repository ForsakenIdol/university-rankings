resource "azurerm_data_factory" "data_factory" {
  name                = "tf-university-rankings-data-factory"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  public_network_enabled = true
  identity {
    type = "SystemAssigned"
  }

  tags = {
    ManagedBy = "Terraform"
  }
}

######################### Linked Services #########################

resource "azurerm_data_factory_linked_service_azure_blob_storage" "blob_storage_link" {
  name                 = "tf-university-rankings-blob-storage-link"
  data_factory_id      = azurerm_data_factory.data_factory.id
  connection_string    = "DefaultEndpointsProtocol=https;AccountName=${var.storage_account_name};AccountKey=${var.storage_account_primary_access_key};EndpointSuffix=core.windows.net"
  storage_kind         = "StorageV2"
  use_managed_identity = true
}

resource "azurerm_data_factory_linked_service_sql_server" "sql_server_link" {
  name              = "tf-university-rankings-sql-server-link"
  data_factory_id   = azurerm_data_factory.data_factory.id
  # Reference for Encrypt=True and TrustServerCertificate=False: https://learn.microsoft.com/en-us/azure/azure-sql/database/security-overview?source=recommendations&view=azuresql#information-protection-and-encryption
  connection_string = "Server=tcp:${var.sql_server_fdqn},1433;Initial Catalog=${var.database_name};User ID=${var.database_admin_username};Password=${var.database_admin_password};Encrypt=True;TrustServerCertificate=False;"
}

