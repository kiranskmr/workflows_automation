## Environment set up locally 

Create a virtual env
```
python3.11 -m venv venv
```

To activate the virtual environment,
```
source venv/bin/activate

```

Install dependencies,
```
pip install -r requirements.txt

```

### Set up Databricks CLI locally

Install databricks cli

 
[For mac](https://docs.databricks.com/en/dev-tools/cli/install.html)
```
brew tap databricks/tap
brew install databricks
```
[Authenticate using Oauth](https://docs.databricks.com/en/dev-tools/cli/authentication.html#oauth-user-to-machine-u2m-authentication)
```
databricks auth login --host <workspace-url>
```


### Set up DBT core locally in your laptop


[Install dbt](https://learn.microsoft.com/en-us/azure/databricks/partners/prep/dbt)
```
Install the `dbt-databricks` package using pip


pip install dbt-databricks

```

sample profiles.yml for [dbt with oauth](https://community.databricks.com/t5/technical-blog/using-dbt-core-with-oauth-on-azure-databricks/ba-p/46605)

create a profiles.yml in /Users/user_name/.dbt We will use a Databricks Personal Acccess Token to connect to the workspace.

```
default:
  target: dev
  outputs:
    dev:
      type: databricks
      catalog: dev
      schema: dbt
      host: workspace.azuredatabricks.net
      http_path: /sql/1.0/warehouses/warehouse-id
      token: <PAT>>

```     

### Running DBT job locally


Local path to profiles.yml can be passed when running locally.

- dbt deps
- dbt build  --profiles-dir=/Users/kiran.sreekumar/.dbt/



### Deploy as workflow in the configured databricks workspace using DAB

If Deploying to Azure Databricks workspace

- databricks bundle validate --var="node_type=Standard_DS3_v2,warehouse_id=<sql warehouse id>"
- databricks bundle deploy --var="node_type=Standard_DS3_v2,warehouse_id=<sql warehouse id>"

If Deploying to AWS Databricks workspace

- databricks bundle validate --var="node_type=i3.xlarge,warehouse_id=<sql warehouse id>"
- databricks bundle deploy --var="node_type= i3.xlarge,warehouse_id=<sql warehouse id>"





### Set up Terraform locally


Install terraform cli

[For mac](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

- brew tap hashicorp/tap
- brew install hashicorp/tap/terraform

[Authenticate](https://registry.terraform.io/providers/databrickslabs/databricks/latest/docs#authentication) using the databrickscfg profile.


### Deploy as workflow in the configured databricks workspace using Terraform


To run locally, rename the file override.tf.example to override.tf


```     
cd terraform/enironments/dev
terraform init
terraform validate
terraform plan
terraform apply
```     



### Run unit test cases locally

install databricks connect if not installed already


```
pip install databricks-connect
databricks-connect configure
DATABRICKS_CLUSTER_ID=<cluster id> pytest src
```
