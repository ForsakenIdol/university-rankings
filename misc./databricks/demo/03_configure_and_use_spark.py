# Configure Spark
spark.conf.set(f"fs.azure.sas.{blob_container_name}.{storage_account_name}.blob.core.windows.net", sas_token)
blob_wasbs_prefix = f"wasbs://{blob_container_name}@{storage_account_name}.blob.core.windows.net/"

# Use Spark
rankings_dataframe = spark.read.csv(blob_wasbs_prefix + blobnames[5])
rankings_dataframe.display()

# How many rows in our dataframe?
print(f"Dataframe row count: {rankings_dataframe.count()}")

# We can also create a view if we want to query the dataframe using SQL
rankings_dataframe.createOrReplaceTempView(name="rankings_df_view")

"""
From hereonout, we can query the data in a new cell using SQL syntax, e.g.

%sql
-- Query the view we just created
SELECT * FROM rankings_df_view LIMIT 15;

"""
