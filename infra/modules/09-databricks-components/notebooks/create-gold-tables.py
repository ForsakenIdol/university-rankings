# Databricks notebook source
# MAGIC %pip install azure-storage-blob azure-identity
# MAGIC dbutils.library.restartPython()

# COMMAND ----------

# Generating the SAS token

from azure.identity import DefaultAzureCredential
from azure.storage.blob import (
    BlobServiceClient,
    ContainerClient,
    BlobClient,
    BlobSasPermissions,
    ContainerSasPermissions,
    UserDelegationKey,
    generate_container_sas,
    generate_blob_sas
)
import datetime

# Top-level settings
storage_account_name = "${storage_account_name}"
blob_container_name = "curated"

# Construct the blob endpoint from the account name
account_url = f"https://{storage_account_name}.blob.core.windows.net"

#Create a BlobServiceClient object using the managed identity client ID
managed_identity_credential = DefaultAzureCredential(
    managed_identity_client_id="${managed_identity_client_id}"
)
blob_service_client = BlobServiceClient(account_url, credential=managed_identity_credential)

# Get a user delegation key that's valid for 1 day
delegation_key_start_time = datetime.datetime.now(datetime.timezone.utc)
delegation_key_expiry_time = delegation_key_start_time + datetime.timedelta(days=1)

# This is the step that requires the actual Storage Blob Delegator permissions on the storage account
user_delegation_key = blob_service_client.get_user_delegation_key(
    key_start_time=delegation_key_start_time,
    key_expiry_time=delegation_key_expiry_time
)

# Get the container client for the "curated" storage container from the blob service client
container_client = blob_service_client.get_container_client(container=blob_container_name)

# Create a SAS token that's valid for one day, as an example
start_time = datetime.datetime.now(datetime.timezone.utc)
expiry_time = start_time + datetime.timedelta(days=1)

sas_token = generate_container_sas(
    account_name=container_client.account_name,
    container_name=container_client.container_name,
    user_delegation_key=user_delegation_key,
    permission=ContainerSasPermissions(
        read=True,
        list=True
        ),
    expiry=expiry_time,
    start=start_time
)

# The SAS token string can be appended to the resource URL with a ? delimiter
# or passed as the credential argument to the client constructor
sas_url = f"{container_client.url}?{sas_token}"
print(sas_url)

# Create a ContainerClient object with SAS authorization from the sas_url we created earlier
# This client can now interact with the target storage container
container_client_sas = ContainerClient.from_container_url(container_url=sas_url)

# COMMAND ----------

# Configure Spark
spark.conf.set(f"fs.azure.sas.{blob_container_name}.{storage_account_name}.blob.core.windows.net", sas_token)
blob_wasbs_prefix = f"wasbs://{blob_container_name}@{storage_account_name}.blob.core.windows.net/"

# Import curated dataframes
blobnames = [blob for blob in container_client_sas.list_blob_names()]
dataframes = [spark.read.csv(blob_wasbs_prefix + blob, header=True, inferSchema=True) for blob in blobnames]

# COMMAND ----------

from pyspark.sql.functions import col

from functools import reduce
from pyspark.sql import DataFrame

# Do some practice cleaning with Spark
# Note: df.dropDuplicates() drops duplicate rows, not duplicate columns
clean_dataframes = []
cast_map = [
    ["ranking_year", "int"],
    ["stats_number_students", "int"],
    ["stats_student_staff_ratio", "double"],
    ["stats_pc_intl_students", "double"],
    ["stats_female_male_ratio", "double"],
    ["stats_proportion_of_isr", "double"]
]
for df in dataframes:
    df_cleaned = df.dropDuplicates()
    for columnName, castType in cast_map: # Destructure each entry in the cast_map list
        df_cleaned = df_cleaned.withColumn(columnName, col(columnName).cast(castType))
    
    processed_year = df.first()['ranking_year']
    # 2017 onwards, we need to divide scores_overall_rank by 10
    if processed_year >= 2017:
        df_cleaned = df_cleaned.withColumn("scores_overall_rank", col("scores_overall_rank") / 10)

    clean_dataframes.append(df_cleaned)
    print(f"Cleaned rankings year {processed_year}", flush=True)  

# Append all cleaned dataframes into one, since they should now all have the same schema
df_aggregate = reduce(DataFrame.union, clean_dataframes)
print(f"Aggregate dataframe has {df_aggregate.count()} rows in total.")

# COMMAND ----------

# From the aggregate dataframe, compute the average scores_overall_rank value for each university based on the "name" field

"""
We can think of the following call chain as being represented by the following SQL query:

SELECT
    name,
    AVG(scores_overall_rank) AS average_overall_score_across_years
FROM df_aggregate
GROUP BY name
ORDER BY average_overall_score_across_years ASC;
"""
df_average_rank = (
    df_aggregate.groupBy("name") # Create the grouping by name
    .agg({"scores_overall_rank": "avg"}) # Aggregate each group from the previous step
    .withColumnRenamed("avg(scores_overall_rank)", "average_overall_rank_across_years") # Rename aggregate column
    .orderBy("average_overall_rank_across_years", ascending=True) # Sort the groups based on the aggregate column
)
# Let's see the first 30 rows
df_average_rank.show(30, truncate=False)

# COMMAND ----------

# DBTITLE 1,Untitled
# Generate another SAS token, but this time to initialize Spark for the "parquet" storage container

parquet_container_client = blob_service_client.get_container_client(container="parquet")
parquet_sas_token = generate_container_sas(
    account_name=parquet_container_client.account_name,
    container_name=parquet_container_client.container_name,
    user_delegation_key=user_delegation_key,
    permission=ContainerSasPermissions(
        read=True,
        list=True,
        write=True,
        delete=True
    ),
    expiry=expiry_time,
    start=start_time
)

spark.conf.set("fs.azure.account.auth.type", "SAS")
spark.conf.set("fs.azure.sas.token.provider.type", "org.apache.hadoop.fs.azurebfs.sas.FixedSASTokenProvider")
spark.conf.set("fs.azure.sas.fixed.token", parquet_sas_token)
blob_abfss_prefix = f"abfss://parquet@{storage_account_name}.dfs.core.windows.net/"

# COMMAND ----------

# Write gold table dataframe to Parquet file in "goldparquet" storage container
# This file gets written as multiple parts, which is expected due to Databricks parallelism
# but we can still reference it by calling the parent folder name "average_rank_year.parquet"
# which will treat it as a single file
(df_average_rank
 .write
 .mode("overwrite")
 .parquet(f"{blob_abfss_prefix}/gold/average_rank_year.parquet")
)