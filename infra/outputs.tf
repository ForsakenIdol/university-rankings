output "raw_and_curated_storage_account_endpoint" {
  value = module.storage_account.raw_and_curated_storage_account_endpoint
}

output "raw_and_curated_storage_account_host" {
  value = module.storage_account.raw_and_curated_storage_account_host
}

output "mssql_server_name" {
  value = module.mssql_database.mssql_server_name
}

output "mssql_server_id" {
  value = module.mssql_database.mssql_server_id
}

output "mssql_server_fdqn" {
  value = module.mssql_database.mssql_server_fdqn
}

output "mssql_database_name" {
  value = module.mssql_database.mssql_database_name
}
