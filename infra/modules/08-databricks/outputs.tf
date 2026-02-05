output "databricks_workspace_url" {
  value = azurerm_databricks_workspace.workspace.workspace_url
}

output "databricks_workspace_id" {
  value = azurerm_databricks_workspace.workspace.id
}

output "databricks_managed_identity_client_id" {
  value = data.azurerm_user_assigned_identity.databricks_managed_identity.client_id
}
