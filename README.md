## Objective: 
Analyse an ecommerce shop using facebook ads and shopify data.

Extract data from the facebook ads api, transform and model the data for analytics and visualize in a dashboard.
Available metrics include CAC, MER and aMER.

![graphic for project overview](images/overview_graphic.png)


## How to replicate this project:
### 1. Create a fresh venv

### 2. Create GCP Service Accounts
You will need one for dlt (extraction) and one for dbt (transformation).
Give them these rights:
dlt-service-account:
BigQuery Data Editor
BigQuery Job User
BigQuery Read Session User

dbt-service-account:
BigQuery Data Editor
BigQuery Job User

### 3. Setting up the extraction with dlt
- cd into extraction/facebook_ads
- Fill out the config.example.toml, secrets.example.toml files and rename them to config.toml, secrets.toml.
- run python3 facebook_ads_pipeline.py

### 4. Setting up transformation with dbt
- cd into transformation/
- copy profiles.example.yml to ~.dbt/
- fill out and rename to profiles.yml
- cd into transformation/online_shop_dbt/ and use 'dbt run' command to run all models. 
- Use 'dbt test' to run all tests.

### 5. Visualization
- not included here for privacy reasons

## Further steps:
Further improvements could be made to this project:
- dockerizing the individual parts
- create ci/cd pipeline and run everything in the cloud
- testing is currently only done in the transformation layer. Testing right in the extraction could be added
