output "data_factory_name" {
    value = azurerm_data_factory.data_factory.name
}

output "data_factory_id" {
    value = azurerm_data_factory.data_factory.id
}

output "data_factory_identity" {
    value = azurerm_data_factory.data_factory.identity
}

output "blob_storage_link_id" {
    value = azurerm_data_factory_linked_service_azure_blob_storage.blob_storage_link.id
}

output "sql_database_link_id" {
    value = azurerm_data_factory_linked_service_azure_sql_database.sql_database_link.id
}

output "blob_storage_link_name" {
    value = azurerm_data_factory_linked_service_azure_blob_storage.blob_storage_link.name
}

output "sql_database_link_name" {
    value = azurerm_data_factory_linked_service_azure_sql_database.sql_database_link.name
}
