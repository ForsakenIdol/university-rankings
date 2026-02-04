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

# Construct the blob endpoint from the account name
account_url = "https://clickopsrankings.blob.core.windows.net"

#Create a BlobServiceClient object using DefaultAzureCredential
blob_service_client = BlobServiceClient(account_url, credential=DefaultAzureCredential())

# Get a user delegation key that's valid for 1 day
delegation_key_start_time = datetime.datetime.now(datetime.timezone.utc)
delegation_key_expiry_time = delegation_key_start_time + datetime.timedelta(days=1)

user_delegation_key = blob_service_client.get_user_delegation_key(
    key_start_time=delegation_key_start_time,
    key_expiry_time=delegation_key_expiry_time
)

# Get the container client for the "curated" storage container from the blob service client
container_client = blob_service_client.get_container_client(container="curated")

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

# Create a ContainerClient object with SAS authorization
# This client can now interact with the target storage container
container_client_sas = ContainerClient.from_container_url(container_url=sas_url)

# Methods on the client that we can call
for entry in dir(container_client_sas):
    if not entry.startswith("_"):
        print(entry)