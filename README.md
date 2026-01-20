# University Rankings

A basic data pipeline on Azure which ingests and cleans the World University Rankings data from Kaggle. [**Dataset Here**](https://www.kaggle.com/datasets/r1chardson/the-world-university-rankings-2011-2023)

## Azure Storage Layout

The plan is to have a single Azure Storage Account with 2 separate containers.
1. `raw`: The raw data, straight from Kaggle.
    - `raw/world_university_rankings/{2011,2012,2013,...}`
    - We'll have a subfolder for each year in the dataset.
2. `curated`: The data after it has been cleaned.
    - `curated/world_university_rankings`

The idea between separating the `raw` and `curated` datasets by containers (instead of just having 2 separate directories in the same container) is to avoid mistakes that lead to data pollution.

## Azure Data Factory

ADF is a service that can copy data from one location to another. Each data copy job is done by a pipeline, and Data Factory is responsible for managing those pipelines for you.

- A dataset is linked to a service the data came from.
- Likewise, datasets can have target linked services where the data must be written to.

In a Data Factory Copy Activity pipeline, datasets determine the source and destination (sink) data formats. The actual data conversion process is handled by the pipeline; it just needs to know the different data formats it is dealing with.

Example use case: Import a .csv file from Azure Blob Storage to Azure SQL.
- For **idempotent pipelines** where the same data might be sent through the pipeline multiple times; the destination (sink) exposes a pre-copy script that allows you to delete the previous corresponding data in the sink (e.g. `DELETE from table-name`).

## Misc. Notes

- We can sync the `raw` data folder up to our storage account's `raw` container using the `azcopy` command-line utility.
