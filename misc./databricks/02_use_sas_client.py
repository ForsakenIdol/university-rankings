# List the blobs
for blobname in container_client_sas.list_blob_names():
    print(blobname)

# Download and read a sample file
rankings_2011_stream = container_client_sas.download_blob("2011_curated_rankings.csv")
rankings_2011_stream.readall()