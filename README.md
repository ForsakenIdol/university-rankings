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
