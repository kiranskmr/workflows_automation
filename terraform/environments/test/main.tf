# import dlt module
module "dlt-pipeline" {
  source = "../../modules/dlt-pipeline"
  dlt_catalog_tf = "test"
  dlt_pipeline_name= "Test Terraform - Customer Order Details - DLT"

 
}

# import sql warehouse module
module "sql-warehouse" {
  source = "../../modules/sql-warehouse"
  env ="test"

}

# import dbt pipeline module
module "dbt-pipeline" {
  source = "../../modules/dbt-pipeline"
  cluster_environment_type = "test"
  volume_catalog           = "test"
  dbt_catalog              = "test"
  depends_on = [module.dlt-pipeline, module.sql-warehouse]
  warehouse_id = module.sql-warehouse.warehouse_id
  pipeline_id = module.dlt-pipeline.pipeline_id
  job_name= "Test Terraform - Customer Order Details"


 
}

# import wheel file module
module "wheel-job" {
source = "../../modules/wheel-job"
volume_catalog = "test"
job_name_whl = "Test Terraform - Wheel File Dependency"

}


# import mlops module
module "mlops-job" {
source = "../../modules/mlops-job"
output_table_catalog = "test"
job_name = "Test Terraform - MLOPS Model-training-job"
job_name_feature ="Test Terraform - MLOPS Write-feature-table-job"
env ="test"
experiment_name="${data.databricks_current_user.me.home}/tf-test-mlops-experiment"
model_name="tf-mlops_model"
}

