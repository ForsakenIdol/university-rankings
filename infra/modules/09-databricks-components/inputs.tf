# We need to redeclare this for some reason to stop Terraform from trying to load the non-existent hashicorp/databricks
terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
    }
  }
}

variable "databricks_workspace_id" {}
variable "storage_account_name" {}
variable "databricks_managed_identity_client_id" {}

# Fetch values for the following, but wait for resource to become available before executing lazy loading
# Where arguments have not been specified, we go for the smallest
data "databricks_current_user" "me" {
  depends_on = [ var.databricks_workspace_id ]
}

data "databricks_spark_version" "runtime_16_4" {
  depends_on = [ var.databricks_workspace_id ]

  scala = "2.12"
  long_term_support = true
}
