output "synapse_workspace_id" {
    value = azurerm_synapse_workspace.synapse_workspace.id
}

output "synapse_serverless_endpoint" {
    value = azurerm_synapse_workspace.synapse_workspace.connectivity_endpoints.sqlOnDemand
}

