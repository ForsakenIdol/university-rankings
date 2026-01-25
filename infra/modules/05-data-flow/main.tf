resource "azurerm_data_factory_data_flow" "data_flow" {
    name = "tf_university_rankings_data_flow"
    data_factory_id  = var.data_factory_id

    source {
        name = "rawData"
        dataset {
            name = var.csv_dataset_source_name
        }
    }

    sink {
        name = "sqlData"
        dataset {
            name = var.sql_dataset_sink_name
        }
    }

    # There is no elegant way to represent the end-to-end data flow other than from a script.
    # This is the exported script from the ClickOps'ed pipeline.
    # It contains the Data Flow's parameters and full logic.
    script = file("${path.module}/dataflows/rankings-dataflow-script.txt")

}
