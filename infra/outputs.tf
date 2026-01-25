# 01-blob-storage

output "raw_and_curated_storage_account_endpoint" {
  value = module.storage_account.raw_and_curated_storage_account_endpoint
}

output "raw_and_curated_storage_account_host" {
  value = module.storage_account.raw_and_curated_storage_account_host
}

# 02-database

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

# 03-data-factory-and-linked-services

output "data_factory_name" {
    value = module.data_factory_skeleton.data_factory_name
}

output "data_factory_id" {
    value = module.data_factory_skeleton.data_factory_id
}

output "data_factory_identity_block" {
    value = module.data_factory_skeleton.data_factory_identity
}

output "data_factory_blob_storage_link_id" {
    value = module.data_factory_skeleton.blob_storage_link_id
}

output "data_factory_sql_server_link_id" {
    value = module.data_factory_skeleton.sql_server_link_id
}

output "data_factory_blob_storage_link_name" {
    value = module.data_factory_skeleton.blob_storage_link_name
}

output "data_factory_sql_server_link_name" {
    value = module.data_factory_skeleton.sql_server_link_name
}

# 04-input-output-datasets


