# List the blobs
blobnames = [blob for blob in container_client_sas.list_blob_names()]
print(blobnames)

# Download and read a sample file
rankings_2011_stream = container_client_sas.download_blob(blobnames[10])
print(f"\nReading {blobnames[10]}:")
rankings_2011_stream.readall().decode().split('\n')[0:2]

