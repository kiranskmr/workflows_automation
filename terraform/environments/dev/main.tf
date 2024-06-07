# import dlt module
module "dlt-pipeline" {
  source = "../../modules/dlt-pipeline"
  dlt_catalog_tf = "dev"
  dlt_pipeline_name= "Dev Terraform - Customer Order Details - DLT job"
 
}

# import sql warehouse module
module "sql-warehouse" {
  source = "../../modules/sql-warehouse"
  env ="dev"

}

# import dbt pipeline module
module "dbt-pipeline" {
  source = "../../modules/dbt-pipeline"
  cluster_environment_type = "dev"
  volume_catalog           = "dev"
  dbt_catalog              = "dev"
  depends_on = [module.dlt-pipeline, module.sql-warehouse]
  warehouse_id = module.sql-warehouse.warehouse_id
  pipeline_id = module.dlt-pipeline.pipeline_id
  job_name= "Dev Terraform - Customer Order Details - DBT job"

 
}

# import wheel file module
module "wheel-job" {
source = "../../modules/wheel-job"
volume_catalog = "dev"
job_name_whl = "Dev Terraform - Python whl File from Volume job"
}


# import mlops module
module "mlops-job" {
source = "../../modules/mlops-job"
output_table_catalog = "dev"
job_name = "Dev Terraform - MLOPS Model training job"
job_name_feature ="Dev Terraform - MLOPS Write feature table job"
env ="dev"
experiment_name="${data.databricks_current_user.me.home}/tf-dev-mlops-experiment"
model_name="tf-mlops_model"
}


