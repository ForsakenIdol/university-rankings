resource "azurerm_data_factory_dataset_azure_blob" "input_dataset_blob" {
    name = "tf_university_rankings_input_dataset_blob"
    data_factory_id = var.data_factory_id
    linked_service_name = var.blob_storage_link_name
    
    parameters = {
        # Unfortunately for us, all parameters are forced to be Strings by default in Terraform.
        CSVFileName = "2021_rankings.csv" 
    }

    path = "raw"
    filename = "@dataset().CSVFileName"

}

resource "azurerm_data_factory_dataset_sql_server_table" "output_dataset_table" {
    name = "tf-university-rankings-output-dataset-table"
    data_factory_id = var.data_factory_id
    linked_service_name = var.sql_server_link_name

    table_name = "dbo.rankings" # `dbo` is the schema, `rankings` is the table name
    
    dynamic "schema_column" {
        # The local parameters are defined in `locals.tf`
        # Doing it this way stops me from having to repeat myself a whole bunch of times
        for_each = local.rankings_table_schema
        content {
            name = schema_column.key
            type = schema_column.value
        }
    }

}
