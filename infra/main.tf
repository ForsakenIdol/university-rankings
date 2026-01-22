resource "azurerm_resource_group" "resource_group" {
  name     = "terraform-university-rankings-project-resources"
  location = "Australia East"
}

module "storage_account" {
  source = "./modules/01-blob-storage"
  resource_group_name = azurerm_resource_group.resource_group.name
  resource_group_location = azurerm_resource_group.resource_group.location
}

module "mssql_database" {
  source = "./modules/02-database"
  resource_group_name = azurerm_resource_group.resource_group.name
  resource_group_location = azurerm_resource_group.resource_group.location
  database_admin_username = "adminuser"
  database_admin_password = "mypass123!"
}
