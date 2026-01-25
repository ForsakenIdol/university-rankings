resource "azurerm_data_factory_dataset_delimited_text" "input_dataset_delimited_text" {
    name = "tf_university_rankings_input_dataset_delimited_text"
    data_factory_id = var.data_factory_id
    linked_service_name = var.blob_storage_link_name
    
    parameters = {
        # Unfortunately for us, all parameters are forced to be Strings by default in Terraform.
        CSVFileName = "2021_rankings.csv" 
    }

    azure_blob_storage_location {
        container = "raw"
        filename = "@dataset().CSVFileName"
    }

    column_delimiter = ","
    first_row_as_header = true

}

resource "azurerm_data_factory_dataset_azure_sql_table" "output_dataset_table" {
    name = "tf-university-rankings-output-dataset-table"
    data_factory_id = var.data_factory_id
    linked_service_id = var.sql_database_link_id

    # `dbo` is the schema, `rankings` is the table name
    schema = "dbo"
    table = "rankings"
    
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
