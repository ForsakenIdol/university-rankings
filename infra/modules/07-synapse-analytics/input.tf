variable "resource_group_name" {}
variable "resource_group_location" {}
variable "storage_account_id" {}

variable "synapse_sql_username" {
    default = "adminuser1"
}

variable "synapse_sql_password" {
    default = "examplepassword123@"
}
