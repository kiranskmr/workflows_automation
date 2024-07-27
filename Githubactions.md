Create three environments

- dev
- test
- prod 


```
Environment secrets
ARM_ACCESS_KEY - Used for terraform state management
CLIENT_SECRET - Secret for the service principal

BUNDLE_VAR_NODE_TYPE - Node type for cluster (Example Standard_DS3_v2 for Azure/ i3.xlarge in AWS )
BUNDLE_VAR_WAREHOUSE_ID - Warehouse created in databricks workspace
CLIENT_ID - Client id for the service principal
CONTAINER_NAME - Container name for the terraform state
DATABRICKS_HOST - Workspace url
GIT_URL - git url where the code is available
RESOURCE_GROUP - Resource group for terraform state 
STORAGE_ACCOUNT - storage account for terraform state
SUBSCRIPTION_ID - subscription where the terraform state storage is created
TENANT_ID - tenant id where the terraform state storage is created
TEST_CLUSTER_ID - cluster used for running test cases

```