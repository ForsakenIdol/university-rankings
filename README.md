# University Rankings

An end-to-end data pipeline on Azure which ingests and cleans the [**World University Rankings**](https://www.kaggle.com/datasets/r1chardson/the-world-university-rankings-2011-2023) dataset from Kaggle.

The raw data for this project can be found in the `raw/` folder of this repository. This data is synced into an Azure blob storage container, loaded into Azure Data Factory through the linked service mechanism, processed in a data flow to derive metrics and clean the data, and finally, used to populate the `rankings` table in an Azure MSSQL database.

## Repository Layout

- `.github/`: Contains workflow integrations for running Terraform commands to spin up the project, as well as a dedicated workflow for running `azcopy` to sync the `raw` dataset up to Azure Blob Storage.
- `infra/`: The Terraform code required to provision Azure project resources.
- `misc./`: Architecture diagrams (see next section) and notes I (ForsakenIdol) took while doing this project.
- `raw/`: The raw CSV files that form the dataset for this project, pulled directly from Kaggle (link above).
- `sql/`: Sandbox and experimentation during the project. If you want to see the actual SQL file that a Terraform `null_resources` uses during database bootstrapping, look in the `infra/modules/02-database/scripts` folder.

## Architecture Diagrams

The following diagrams show what the `infra/` folder architecture looks like when created with `terraform apply`.

<p align="center">
    <image src="misc./diagrams/terraform-university-rankings-project-resources.png"
        alt="Azure Resource Visualizer" width="70% "/>
</p>

<p align="center">
    <image src="misc./diagrams/terraform-infra-graph.png"
        alt="Terraform PNG Graph"/>
</p>

Consider expanding out the directed graph in a new tab to see the full structure.

## Using this Project

If you fork this repository into your own GitHub account and want to use the workflows, you'll need the following:

- A `TERRAFORM_API_TOKEN` to make use of the upstream HCP Terraform Cloud for TF state management.
- Your `AZURE_SUBSCRIPTION_ID` to indicate which subscription to launch resources into.
- Your `AZURE_CLIENT_ID` and `AZURE_TENANT_ID`, which correspond to a user-assigned **managed identity** that you can use to give the workflow permission to launch resources into your Microsoft Azure account. Note that creating the identity is not enough; you must also allow GitHub to assume the identity by configuring its **federated credentials**.

You can also clone the repository locally and run Terraform commands from the `infra/` folder.

Note that the `ForEach` driver pipeline currently doesn't have an automatic trigger. You'll need to "Trigger now" with all the data in place to get it to run. A full end-to-end run of the pipeline shouldn't take more than 10 minutes.

<p align="center">
    <image src="misc./diagrams/example-driver-pipeline-full-run.png"
        alt="Driver Pipeline Execution"/>
</p>
