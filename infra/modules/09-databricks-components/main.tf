resource "databricks_cluster" "default_cluster" {
    cluster_name = "tf-uni-rankings-default-cluster"
    spark_version = data.databricks_spark_version.latest.id
    node_type_id = data.databricks_node_type.smallest.id

    kind = "CLASSIC_PREVIEW"
    is_single_node = true
    data_security_mode = "DATA_SECURITY_MODE_AUTO"
    autotermination_minutes = 180
    
}

resource "databricks_notebook" "gold_tables" {
    path     = "${data.databricks_current_user.me.home}/tf-create-gold-tables" # This must be an absolute path
    language = "PYTHON"
    content_base64 = base64encode(templatefile("${path.module}/notebooks/create-gold-tables.py", {
        storage_account_name = var.storage_account_name
    }))
}
