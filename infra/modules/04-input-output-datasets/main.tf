resource "azurerm_data_factory_dataset_delimited_text" "input_dataset_delimited_text" {
  name                = "tf_university_rankings_input_dataset_delimited_text"
  data_factory_id     = var.data_factory_id
  linked_service_name = var.blob_storage_link_name

  parameters = {
    # Unfortunately for us, all parameters are forced to be Strings by default in Terraform.
    CSVFileName = ""
  }

  azure_blob_storage_location {
    container = "raw"
    filename  = "@dataset().CSVFileName"
  }

  column_delimiter    = ","
  row_delimiter       = "\n"
  first_row_as_header = true

}

resource "azurerm_data_factory_dataset_sql_server_table" "output_dataset_table" {
  name                = "tf_university_rankings_output_dataset_sql_server_table"
  data_factory_id     = var.data_factory_id
  linked_service_name = var.sql_server_link_name

  # `dbo` is the schema, `rankings` is the table name
  table_name = "dbo.rankings"

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

resource "azurerm_data_factory_dataset_delimited_text" "output_dataset_delimited_text" {
  name                = "tf_university_rankings_output_dataset_delimited_text"
  data_factory_id     = var.data_factory_id
  linked_service_name = var.blob_storage_link_name

  azure_blob_storage_location {
    container = "curated"
  }

  column_delimiter    = ","
  row_delimiter       = "\n"
  first_row_as_header = true

}
