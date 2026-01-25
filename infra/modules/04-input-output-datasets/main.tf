resource "azurerm_data_factory_dataset_azure_blob" "input_dataset_blob" {
    name = "tf-university-rankings-input-dataset-blob"
    data_factory_id = var.data_factory_id
    linked_service_name = var.blob_storage_link_name
    
    parameters = {
        # Unfortunately for us, all parameters are forced to be Strings by default in Terraform.
        CSVFileName = "2021_rankings.csv" 
    }

    path = "raw"
    filename = "@dataset().CSVFileName"

}

# resource "azurerm_data_factory_dataset_sql_server_table" "output_dataset_table" {
#     name = "tf-university-rankings-output-dataset-table"
# }
