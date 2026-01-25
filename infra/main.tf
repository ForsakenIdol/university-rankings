resource "azurerm_resource_group" "resource_group" {
  name     = "terraform-university-rankings-project-resources"
  location = "Australia East"
}

module "storage_account" {
  source                  = "./modules/01-blob-storage"
  
  resource_group_name     = azurerm_resource_group.resource_group.name
  resource_group_location = azurerm_resource_group.resource_group.location
}

module "mssql_database" {
  source                  = "./modules/02-database"

  resource_group_name     = azurerm_resource_group.resource_group.name
  resource_group_location = azurerm_resource_group.resource_group.location
  database_admin_username = var.database_admin_username
  database_admin_password = var.database_admin_password
}

module "data_factory_skeleton" {
  source = "./modules/03-data-factory-and-linked-services"

  resource_group_name     = azurerm_resource_group.resource_group.name
  resource_group_location = azurerm_resource_group.resource_group.location

  storage_account_primary_connection_string = module.storage_account.primary_connection_string

  database_admin_username = var.database_admin_username
  database_admin_password = var.database_admin_password
  sql_server_fdqn = module.mssql_database.mssql_server_fdqn
  database_name = module.mssql_database.mssql_database_name
}

module "input_output_datasets" {
  source = "./modules/04-input-output-datasets"

  data_factory_id = module.data_factory_skeleton.data_factory_id
  blob_storage_link_name = module.data_factory_skeleton.blob_storage_link_name
  sql_database_link_id = module.data_factory_skeleton.sql_database_link_id
}

module "data_flow" {
  source = "./modules/05-data-flow"

  data_factory_id = module.data_factory_skeleton.data_factory_id
  csv_dataset_source_name = module.input_output_datasets.input_csv_dataset_name
  sql_dataset_sink_name = module.input_output_datasets.output_sql_dataset_name
}
