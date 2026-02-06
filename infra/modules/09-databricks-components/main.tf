resource "databricks_service_principal" "managed_identity_mapping" {
    application_id = var.databricks_managed_identity_client_id
    display_name = "dbmanagedidentity_manual_assignment"
}

resource "databricks_cluster" "default_cluster" {
    cluster_name = "tf-uni-rankings-default-cluster"
    spark_version = data.databricks_spark_version.runtime_16_4.id
    node_type_id = "Standard_D4ds_v5" # data.databricks_node_type.smallest.id

    kind = "CLASSIC_PREVIEW"
    is_single_node = true
    runtime_engine = "PHOTON"
    data_security_mode = "SINGLE_USER"
    single_user_name = data.databricks_current_user.me.user_name
    autotermination_minutes = 180

    spark_conf = {
        "spark.databricks.unityCatalog.enabled": false
    }
    
}

resource "databricks_notebook" "gold_tables" {
    path     = "${data.databricks_current_user.me.home}/tf-create-gold-tables" # This must be an absolute path
    language = "PYTHON"
    content_base64 = base64encode(templatefile("${path.module}/notebooks/create-gold-tables.py", {
        storage_account_name = var.storage_account_name
        managed_identity_client_id = var.databricks_managed_identity_client_id
    }))
}
