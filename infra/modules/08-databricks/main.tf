resource "azurerm_databricks_workspace" "workspace" {
    name = "tf-uni-rankings-databricks-workspace"
    resource_group_name = var.resource_group_name
    location = var.resource_group_location

    sku = "standard"
    managed_resource_group_name = var.databricks_managed_resource_group_name
    public_network_access_enabled = true

}

data "azurerm_user_assigned_identity" "databricks_managed_identity" {
    depends_on = [ azurerm_databricks_workspace.workspace ]

    name = "dbmanagedidentity"
    resource_group_name = var.databricks_managed_resource_group_name
}

resource "azurerm_role_assignment" "sas_token_permissions" {
    scope = var.storage_account_id
    role_definition_name = "Storage Blob Delegator"
    principal_id = data.azurerm_user_assigned_identity.databricks_managed_identity.principal_id
}

resource "azurerm_role_assignment" "read_and_write_to_storage_account" {
    scope = var.storage_account_id
    role_definition_name = "Storage Blob Data Contributor"
    principal_id = data.azurerm_user_assigned_identity.databricks_managed_identity.principal_id
}

