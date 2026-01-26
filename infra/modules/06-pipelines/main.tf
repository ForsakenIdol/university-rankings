resource "azurerm_data_factory_pipeline" "wrapper_pipeline" {
  name            = "tf-university-rankings-wrapper-pipeline"
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

# ForEach Driver Pipeline
resource "azurerm_data_factory_pipeline" "driver_pipeline" {
  name            = "tf-university-rankings-driver-pipeline"
  data_factory_id = var.data_factory_id

  # Array parameters must be JSON encoded. Unfortunately, that means we cannot specify them here,
  # because Terraform can only pass strings. Therefore, we encode it inside the template file.
  activities_json = templatefile(
    "${path.module}/pipeline_json_definitions/driver-pipeline.json",
    {
      wrapper_pipeline_name = azurerm_data_factory_pipeline.wrapper_pipeline.name
    }
  )

  # Driver pipeline should only be created after wrapper pipeline.
  depends_on = [azurerm_data_factory_pipeline.wrapper_pipeline]
}
