output "mssql_server_name" {
  value = azurerm_mssql_server.sql_server.name
}

output "mssql_server_id" {
  value = azurerm_mssql_server.sql_server.id
}

output "mssql_server_fdqn" {
  value = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}

output "mssql_database_name" {
  value = azurerm_mssql_database.mssql_database.name
}
