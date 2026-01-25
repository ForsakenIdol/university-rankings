output "input_csv_dataset_name" {
    value = azurerm_data_factory_dataset_delimited_text.input_dataset_delimited_text.name
}

output "output_sql_dataset_name" {
    value = azurerm_data_factory_dataset_sql_server_table.output_dataset_table.name
}