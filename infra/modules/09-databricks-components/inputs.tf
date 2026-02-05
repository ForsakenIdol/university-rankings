# We need to redeclare this for some reason to stop Terraform from trying to load the non-existent hashicorp/databricks
terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
    }
  }
}

variable "databricks_workspace_id" {}

# Fetch defaults, but wait for resource to become available before executing lazy loading
data "databricks_current_user" "me" {
  depends_on = [ var.databricks_workspace_id ]
}

data "databricks_spark_version" "latest" {
  depends_on = [ var.databricks_workspace_id ]
}

data "databricks_node_type" "smallest" {
  depends_on = [ var.databricks_workspace_id ]
}
