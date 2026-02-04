## Azure Storage Layout

The plan is to have a single Azure Storage Account with 2 separate containers.
1. `raw`: The raw data, straight from Kaggle.
    - `raw/world_university_rankings`
    - The dataset we're using separates each year into a different `.csv` file (`2011_rankings.csv` to `2024_rankings.csv`), so we don't need separate folders for each year's dataset in the `raw` source container.
2. `curated`: The data after it has been cleaned.
    - `curated/world_university_rankings`
    - Might as well just export the full table as is, since most of the curation is done in the data flow pipeline.

The idea between separating the `raw` and `curated` datasets by containers (instead of just having 2 separate directories in the same container) is to avoid mistakes that lead to data pollution.

## SQL Layout

The `curated` data will not be populated until later. Our first step will be to use Data Factory to load the data from the `raw` storage container into an Azure SQL database.

Initial potential idea: To load all the different ranking years into the same table, have a separate `year` column that dictates the year a ranking was made, with values from `[2011-2024]` inclusive.

## Azure Data Factory

ADF is a service that can copy data from one location to another. Each data copy job is done by a pipeline, and Data Factory is responsible for managing those pipelines for you.

- A dataset is linked to a service the data came from.
- Likewise, datasets can have target linked services where the data must be written to.

In a Data Factory Copy Activity pipeline, datasets determine the source and destination (sink) data formats. The actual data conversion process is handled by the pipeline; it just needs to know the different data formats it is dealing with.

Example use case: Import a .csv file from Azure Blob Storage to Azure SQL.
- For **idempotent pipelines** where the same data might be sent through the pipeline multiple times; the destination (sink) exposes a pre-copy script that allows you to delete the previous corresponding data in the sink (e.g. `DELETE from table-name`).

## Misc. Notes

- We can sync the `raw` data folder up to our storage account's `raw` container using the `azcopy` command-line utility.
- Create the linked services before the datasets.
- For the database, use `Azure SQL Database` as the integration. Note that this is an MSSQL database.
- For the storage account, use `Azure Blob Storage` as the integration.
- For the data factory, we need to create a **Data Flow**, not a Copy pipeline.
    - `rawData -> fixScoresColumns -> sqlData`
    - Debug mode is super useful to visualize what's going on in the data flow.
    - Then, to actually execute the data flow, we need to add it to a pipeline, like any other resource.
- Don't delete the pipeline that was created via ClickOps! Use it as a reference when creating the Terraform stuff in another resource group.
- VARCHAR without an explicit size has a default length of 1 character in SQL Server.
- Arrays in the Data Flow Derived Column modifier's expression builder are **1-indexed**. This means the first element is accessible at index 1, **not** index 0.
- When integrating the SQL database into Data Factory using a **linked service** approach with Terraform, to do so with a pure SQL connection method, you must use the `azurerm_data_factory_linked_service_sql_server` resource. The other resource, `azurerm_data_factory_linked_service_azure_sql_database`, does not support pure SQL connection methods when instantiated in Terraform.

Terraform graph creation from `infra/` folder:

```sh
tf graph | dot -Tpng > ../misc./diagrams/terraform-infra-graph.png
```

## Azure Data Lake Storage (DLS)

*(The term "blob" is actually an acronym in the Big Data space. It stands for "Binary Large Object".)*

Synapse Analytics needs to be created over a [**Data Lake Storage Gen2**](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction) resource, which is itself built on top of Azure Blob Storage. It seems to build a Data Lake that is backed by Azure Storage, and provides capabilities over the backing blob storage account.

- **DLS Gen2** is not a service by itself; rather, it is a feature [**configured on top of a Storage Account**](https://learn.microsoft.com/en-us/training/modules/introduction-to-azure-data-lake-storage/3-create-data-lake-account).
    - When the storage account kind is `StorageV2` (general-purpose V2) and the **Hierarchical Namespace** feature is enabled, the storage account itself becomes enabled for DLS Gen2.
    - The hierarchical namespace feature, when enabled, adds a **true file hierarchy** on top of the object storage, enabling file-system-style operations and fine-grained permissions like ACLs at the directory or file level. This feature also makes the storage account compatible with engines which expect file system semantics, like Spark, or Synapse Analytics.
    - You can't revert the storage account back to using a flat namespace. Once enabled, it stays enabled. However, it doesn't look like this affects existing linked service configurations with Azure Data Factory.
- DLS Gen2 can be enabled when a storage account is created, or after the storage account is created.
    - The corresponding Terraform setting to do this is `is_hns_enabled` for the `azurerm_storage_account` resource. However, changing this value forces a new resource to be created.

## Azure Synapse

Synapse can connect to the DLS Gen2 endpoint as a linked service. Synapse itself also exposes a **Dedicated SQL endpoint** which we can connect to to run SQL queries and create external data sources from files that we can query over.

- External tables over external data do not support primary key declarations. You must enforce uniqueness further up in the pipeline.
- The order of columns in an external table must match the loaded data in both name and column order. Azure Synapse Analytics does not match column names; it only loads in the specified order.

## Databricks

The vast majority of what you do in Databricks is in the Databricks portal itself, and not in the Azure portal. It looks like we'll need to use the [**Databricks Terraform Provider**](https://github.com/databricks/terraform-provider-databricks/blob/main/docs/guides/azure-workspace.md) and configure it to start after and dependent on the [`azurerm_databricks_workspace`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace) resource being created.

- The ClickOps Databricks workspace takes a really long time to deploy, but it does eventually complete.

One of the ways we can authenticate Databricks to an Azure Storage Account container (preferred) or individual blob is to generate a SAS token. This will require a few libraries in Python, so we set the first Python cell to install them:

```sh
%pip install azure-storage-blob azure-identity
dbutils.library.restartPython()
```

- The Databricks managed identity (usually called `dbmanagedidentity` and followed by an application UUID) needs **Storage Blob Delegator** role permissions on the storage account to generate SAS tokens for the given account.
- These need to be given on the storage account itself to allow the managed identity to perform the necessary functions on it.

Then, to actually interact with and get blobs from within the container:

1. The Databricks managed identity needs The **Storage Blob Data Reader** (or above) permissions on the storage account.
2. The `ContainerSasPermissions` Python block needs to provide `list` permissions for the blobs alongside `read` permissions for the contents of any given blob.
3. Alternatively, if the workbook needs to write back to the container (e.g. parquet files, gold tables), just use the **Storage Blob Data Contributor** role instead for the mapping.
