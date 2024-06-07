terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}


# Retrieve information about the current user.
data "databricks_current_user" "me" {}




variable "job_name" {
  description = "A name for the job."
  type        = string
  default     = "Model-training-job"
}


variable "notebook_train" {
  description = "folder for file"
  type        = string
  default     = "training/notebooks/TrainWithFeatureStore"
}

variable "notebook_validate" {
  description = "folder for file"
  type        = string
  default     = "validation/notebooks/ModelValidation"
}

variable "notebook_deploy" {
  description = "folder for file"
  type        = string
  default     = "deployment/model_deployment/notebooks/ModelDeployment"
}




variable "env" {
  description = "env"
  type        = string
}


variable "experiment_name" {
  description = "experiment_name"
  type        = string
}

variable "model_name" {
  description = "model_name"
  type        = string
}





resource "databricks_job" "train_validate" {
  name   = var.job_name
  format = "MULTI_TASK"
   tags = {
    owner = "${data.databricks_current_user.me.alphanumeric}"
    source= "Terraform"
    env= var.env
  }
  job_cluster {
    new_cluster {
      spark_version = data.databricks_spark_version.ml.id
      node_type_id  = data.databricks_node_type.smallest.id
      custom_tags   = { ResourceClass = "MultiNode" }
      spark_env_vars = {
        PYSPARK_PYTHON = "/databricks/python3/bin/python3"
      }
      num_workers        = 1
      data_security_mode = "SINGLE_USER"


    }
    job_cluster_key = "model_training_shared_cluster"
  }


  git_source {
    url      = "https://github.com/kiranskmr/workflows_automation.git"
    provider = "gitHub"
    branch   = "main"
  }

  task {
    task_key        = "Train"
    job_cluster_key = "model_training_shared_cluster"
    notebook_task {
      notebook_path = var.notebook_train
      source        = "GIT"
      base_parameters = {
              env: "${var.env}"
              training_data_path: "/databricks-datasets/nyctaxi-with-zipcodes/subsampled"
              experiment_name: "${var.experiment_name}"
              model_name: "${var.env}.mlops_tf.${var.model_name}"
              pickup_features_table: "${var.env}.mlops_tf.trip_pickup_features"
              dropoff_features_table: "${var.env}.mlops_tf.trip_dropoff_features"
      }

    }
  }


  task {
    task_key        = "ModelValidation"
    job_cluster_key = "model_training_shared_cluster"
    depends_on {
      task_key = "Train"
    }
    notebook_task {
      notebook_path = var.notebook_validate
      source        = "GIT"
      base_parameters = {
              env: "${var.env}"
              training_data_path: "/databricks-datasets/nyctaxi-with-zipcodes/subsampled"
              experiment_name: "${var.experiment_name}"
              model_name: "${var.env}.mlops.${var.model_name}"
              pickup_features_table: "${var.env}.mlops.trip_pickup_features"
              dropoff_features_table: "${var.env}.mlops.trip_dropoff_features"
              run_mode: "dry_run"
              enable_baseline_comparison: "false"
              validation_input: "SELECT * FROM delta.`dbfs:/databricks-datasets/nyctaxi-with-zipcodes/subsampled`"
              model_type: "regressor"
              targets: "fare_amount"
              custom_metrics_loader_function: "custom_metrics"
              validation_thresholds_loader_function: "validation_thresholds"
              evaluator_config_loader_function: "evaluator_config"
      }

    }
  }


    task {
    task_key        = "ModelDeployment"
    job_cluster_key = "model_training_shared_cluster"
    depends_on {
      task_key = "ModelValidation"
    }
    notebook_task {
      notebook_path = var.notebook_deploy
      source        = "GIT"
      base_parameters = {
              env: "${var.env}"
              training_data_path: "/databricks-datasets/nyctaxi-with-zipcodes/subsampled"
              experiment_name: "${var.experiment_name}"
              model_name: "${var.env}.mlops.${var.model_name}"
              pickup_features_table: "${var.env}.mlops.trip_pickup_features"
              dropoff_features_table: "${var.env}.mlops.trip_dropoff_features"
              run_mode: "dry_run"
              enable_baseline_comparison: "false"
              validation_input: "SELECT * FROM delta.`dbfs:/databricks-datasets/nyctaxi-with-zipcodes/subsampled`"
              model_type: "regressor"
              targets: "fare_amount"
              custom_metrics_loader_function: "custom_metrics"
              validation_thresholds_loader_function: "validation_thresholds"
              evaluator_config_loader_function: "evaluator_config"
      }
 
    

    }
    
  }


    schedule {
        quartz_cron_expression= "0 0 9 * * ?"
        timezone_id= "UTC"
        }
  
}




  