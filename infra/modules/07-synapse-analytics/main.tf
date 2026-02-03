resource "azurerm_storage_data_lake_gen2_filesystem" "dls_gen2_fs" {
    name = "tf-uni-rankings-data-lake-storage-gen2-file-system"
    storage_account_id = var.storage_account_id
}

resource "azurerm_synapse_workspace" "synapse_workspace" {
    name = "tf-uni-rankings-synapse-workspace"
    resource_group_name = var.resource_group_name
    location = var.resource_group_location
    storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.dls_gen2_fs.id
    sql_administrator_login = var.synapse_sql_username
    sql_administrator_login_password = var.synapse_sql_password
    managed_resource_group_name = "tf-uni-rankings-synapse-managed-resource-group"

    identity {
        type = "SystemAssigned"
    }
}

resource "azurerm_synapse_firewall_rule" "allow_all" {
    name = "AllowAllTraffic"
    synapse_workspace_id = azurerm_synapse_workspace.synapse_workspace.id
    start_ip_address     = "0.0.0.0"
    end_ip_address       = "255.255.255.255"
}

# Bootstrap workspace via SQL script

resource "local_file" "rendered_init_sql_template_script" {
    content = templatefile(
        "${path.module}/scripts/01-initialize-database-and-external-table.sql",
        {
            storage_account_name = "tfunirankings"
        }
    )
    filename = "${path.module}/rendered_init.sql"
}

resource "null_resource" "initialize_database" {
  depends_on = [
    azurerm_synapse_firewall_rule.allow_all,
    local_file.rendered_init_sql_template_script
  ]

  triggers = {
    init_script_hash = filemd5("${path.module}/scripts/01-initialize-database-and-external-table.sql")
  }

  provisioner "local-exec" {
    # EOC: End of Command
    # -S server-hostname -d database-name -U username -P password -i script-to-execute.sql
    command = <<EOC
sqlcmd \
  -S ${trimprefix(azurerm_synapse_workspace.synapse_workspace.connectivity_endpoints.sqlOnDemand, "https://")} \
  -d master \
  -U ${var.synapse_sql_username} \
  -P ${var.synapse_sql_password} \
  -i ${local_file.rendered_init_sql_template_script.filename} \
  -o "${path.module}/sqlcmd_output.log"
EOC
  }

  provisioner "local-exec" {
    when = destroy
    command = "rm -f ${path.module}/rendered_init.sql"
  }
}

