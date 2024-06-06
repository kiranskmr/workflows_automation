


resource "databricks_registered_model" "this" {
       
        name = var.model_name
        catalog_name = var.env
        schema_name= "mlops_tf"
        comment= " Registered model in Unity Catalog for the mlops ML Project for ${var.env} deployment target."
        }


resource "databricks_mlflow_experiment" "this" {
    

    name= var.experiment_name
    description = "MLflow Experiment used to track runs for mlops project."

    }
    



