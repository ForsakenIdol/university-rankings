resource "azurerm_data_factory_pipeline" "wrapper_pipeline" {
    name = "tf-university-rankings-wrapper-pipeline"
    data_factory_id = var.data_factory_id

    parameters = {
        PipelineProcessingYear = "2012"
    }

    activities_json = templatefile(
        "${path.module}/pipeline_json_definitions/wrapper-pipeline.json",
        {
            data_flow_name = var.data_flow_name
        }
    )
    
}

# TODO: Driver Pipeline
