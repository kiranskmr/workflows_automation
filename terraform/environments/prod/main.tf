# import dlt module
module "dlt-pipeline" {
  source = "../../modules/dlt-pipeline"
  dlt_catalog_tf = "prod"
  dlt_pipeline_name= "Terraform - Customer Order Details - DLT"

 
}

# import sql warehouse module
module "sql-warehouse" {
  source = "../../modules/sql-warehouse"
  env =""

}

# import dbt pipeline module
module "dbt-pipeline" {
  source = "../../modules/dbt-pipeline"
  cluster_environment_type = "prod"
  volume_catalog           = "prod"
  dbt_catalog              = "prod"
  depends_on = [module.dlt-pipeline, module.sql-warehouse]
  warehouse_id = module.sql-warehouse.warehouse_id
  pipeline_id = module.dlt-pipeline.pipeline_id
  job_name= "Terraform - Customer Order Details"


 
}

# import wheel file module
module "wheel-job" {
source = "../../modules/wheel-job"
volume_catalog = "prod"
job_name_whl = "Terraform - Wheel File Dependency"

}



# import mlops module
module "mlops-job" {
source = "../../modules/mlops-job"
output_table_catalog = "prod"
job_name = "Terraform - MLOPS Model-training-job"
job_name_feature ="Terraform - MLOPS Write-feature-table-job"
env ="prod"
experiment_name="${data.databricks_current_user.me.home}/tf-prod-mlops-experiment"
model_name="tf-mlops_model"
}
