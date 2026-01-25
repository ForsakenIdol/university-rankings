output "raw_and_curated_storage_account_endpoint" {
  value = azurerm_storage_account.raw_and_curated_storage_account.primary_blob_endpoint
}

output "raw_and_curated_storage_account_host" {
  value = azurerm_storage_account.raw_and_curated_storage_account.primary_blob_host
}

output "primary_connection_string" {
  value = azurerm_storage_account.raw_and_curated_storage_account.primary_connection_string
}

output "raw_and_curated_storage_account_name" {
  value = azurerm_storage_account.raw_and_curated_storage_account.name
}

output "primary_access_key" {
  value = azurerm_storage_account.raw_and_curated_storage_account.primary_access_key
}
