resource "azurerm_mssql_server" "sql_server" {
    name = "tf-university-rankings-sql-server"
    resource_group_name = var.resource_group_name
    location = var.resource_group_location
    version = "12.0"

    administrator_login = var.database_admin_username
    administrator_login_password = var.database_admin_password
    # No `azuread_administrator` block means no Microsoft Entra authentication is configured for this resource.
}

resource "azurerm_mssql_database" "mssql_database" {
    name = "tf-university-rankings-mssql-database"
    server_id = azurerm_mssql_server.sql_server.id

    collation = "SQL_Latin1_General_CP1_CI_AS"
    max_size_gb = 2
    sku_name = "GP_S_Gen5_1"
}

# Bootstrap database
resource "null_resource" "initialize_database" {
    depends_on = [ azurerm_mssql_database.mssql_database ]

    triggers = {
        # When we make edits to the SQL script file, we will "re-provision" this null resource,
        # i.e. we'll run the script again.
        init_script_hash = filemd5("${path.module}/scripts/init.sql")
    }

    provisioner "local-exec" {
        # EOC: End of Command
        command = <<EOC
sqlcmd ^
  -S ${azurerm_mssql_server.sql_server.name}.database.windows.net ^
  -d ${azurerm_mssql_database.mssql_database.name} ^
  -U ${var.database_admin_username} ^
  -P "${var.database_admin_password}" ^
  -i "${path.module}/scripts/init.sql"
EOC
    }

}
