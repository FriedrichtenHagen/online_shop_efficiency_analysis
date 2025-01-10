Objective: 
Analyze the efficiency of a client’s online store with a focus on evaluating
their marketing efforts. 
The client operates on Shopify and currently advertises only on
Meta platforms. 
You will be provided with access to Meta's API credentials and an order
export from Shopify in CSV format. 
Your task is to extract, process, and visualize the
data to analyze Customer Acquisition Cost (CAC), Marketing Efficiency Ratio (MER),
and Adjusted Marketing Efficiency Ratio (aMER) on a daily basis.


Graphic that shows project architecture:
...



Here are the steps to replicate:
...


Setup Bigquery project:
1. Log in to or create a Google Cloud account

Sign up for or log in to the Google Cloud Platform in your web browser.

2. Create a new Google Cloud project

After arriving at the Google Cloud console welcome page, click the project selector in the top left, then click the New Project button, and finally click the Create button after naming the project whatever you would like.

3. Create a service account and grant BigQuery permissions

You will then need to create a service account. After clicking the Go to Create service account button on the linked docs page, select the project you created and name the service account whatever you would like.

Click the Continue button and grant the following roles, so that dlt can create schemas and load data:

BigQuery Data Editor
BigQuery Job User
BigQuery Read Session User
You don't need to grant users access to this service account now, so click the Done button.

You don't need to grant users access to this service account now, so click the Done button.

4. Download the service account JSON

In the service accounts table page that you're redirected to after clicking Done as instructed above, select the three dots under the Actions column for the service account you created and select Manage keys.

This will take you to a page where you can click the Add key button, then the Create new key button, and finally the Create button, keeping the preselected JSON option.

A JSON file that includes your service account private key will then be downloaded.

5. Update your dlt credentials file with your service account info


Setup dlt:
...
config.toml
secrets.toml

Further steps:
Further improvements could be made to this project: docker, testing
