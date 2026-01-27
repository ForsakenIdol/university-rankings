resource "azurerm_mssql_server" "sql_server" {
  name                = "tf-university-rankings-sql-server"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  version             = "12.0"

  administrator_login          = var.database_admin_username
  administrator_login_password = var.database_admin_password
  # No `azuread_administrator` block means no Microsoft Entra authentication is configured for this resource.
}

# This rule allows Azure services only.
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# This rule allows a broader range of public access. Azure does not support a "global access" rule,
# so we need to approximate global access with a broad firewall range.
resource "azurerm_mssql_firewall_rule" "allow_public_traffic" {
  name             = "AllowMostPublicTraffic"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "1.0.0.0"
  end_ip_address   = "254.255.255.0"
}

resource "azurerm_mssql_database" "mssql_database" {
  name      = "tf-university-rankings-mssql-database"
  server_id = azurerm_mssql_server.sql_server.id

  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  auto_pause_delay_in_minutes = -1 # Disable auto-pause for this serverless database
  min_capacity                = 0.5
  max_size_gb                 = 2
  sku_name                    = "GP_S_Gen5_1"
}

# Bootstrap database by running the init.sql script to create the rankings table
resource "null_resource" "initialize_database" {
  depends_on = [azurerm_mssql_database.mssql_database]

  triggers = {
    # When we make edits to the SQL script file, we will "re-provision" this null resource,
    # i.e. we'll run the script again.
    init_script_hash = filemd5("${path.module}/scripts/01-init.sql")
  }

  provisioner "local-exec" {
    # EOC: End of Command
    command = <<EOC
sqlcmd \
  -S ${azurerm_mssql_server.sql_server.name}.database.windows.net \
  -d ${azurerm_mssql_database.mssql_database.name} \
  -U ${var.database_admin_username} \
  -P "${var.database_admin_password}" \
  -i "${path.module}/scripts/init.sql"
EOC
  }

}
