resource "azurerm_data_factory" "data_factory" {
    name = "tf-universiy-rankings-data-factory"
    resource_group_name = var.resource_group_name
    location = var.resource_group_location

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
    name = "tf-university-rankings-blob-storage-link"
    data_factory_id = azurerm_data_factory.data_factory.id
    connection_string = "DefaultEndpointsProtocol=https;AccountName=${var.storage_account_name};AccountKey=${var.storage_account_primary_access_key};EndpointSuffix=core.windows.net"
}

resource "azurerm_data_factory_linked_service_azure_sql_database" "sql_database_link" {
    name = "tf-university-rankings-sql-database-link"
    data_factory_id = azurerm_data_factory.data_factory.id
    # Reference for Encrypt=True and TrustServerCertificate=False: https://learn.microsoft.com/en-us/azure/azure-sql/database/security-overview?source=recommendations&view=azuresql#information-protection-and-encryption
    connection_string = "Data Source=${var.sql_server_fdqn};Initial Catalog=${var.database_name};User ID=${var.database_admin_username};Password=${var.database_admin_password};Encrypt=True;TrustServerCertificate=False"
}
