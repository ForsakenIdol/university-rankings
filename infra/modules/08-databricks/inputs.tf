variable "resource_group_name" {}
variable "resource_group_location" {}
variable "storage_account_id" {}

variable "databricks_managed_resource_group_name" {
    default = "tf-uni-rankings-databricks-managed-resources"
}
