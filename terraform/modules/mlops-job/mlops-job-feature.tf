



variable "job_name_feature" {
  description = "A name for the job."
  type        = string
  default     = "Write-feature-table-job"
}
variable "output_table_catalog" {
  description = "output table names"
  type        = string
}

# Create the cluster with the "smallest" amount
# of resources allowed.
data "databricks_node_type" "smallest" {
  local_disk = true
}

# Use the latest Databricks Runtime
# Long Term Support (LTS) version.
data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

data "databricks_spark_version" "ml" {
  ml                = true
  long_term_support = true
}

variable "notebook_write" {
  description = "folder for file"
  type        = string
  default     = "feature_engineering/notebooks/GenerateAndWriteFeatures"
}




resource "databricks_job" "this" {
  name   = var.job_name_feature
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
    job_cluster_key = "ml_shared_cluster"
  }


  git_source {
    url      = "https://github.com/kiranskmr/workflows_automation.git"
    provider = "gitHub"
    branch   = "main"
  }

  task {
    task_key        = "PickupFeatures"
    job_cluster_key = "ml_shared_cluster"
    notebook_task {
      notebook_path = var.notebook_write
      source        = "GIT"
      base_parameters = {
              input_start_date: ""
              input_end_date: ""
              timestamp_column: "tpep_pickup_datetime"
              output_table_name: "${var.output_table_catalog}.mlops_tf.trip_pickup_features"
              features_transform_module: "pickup_features"
              primary_keys: "zip"
      }

    }
  }

    task {
    task_key        = "DropoffFeatures"
    job_cluster_key = "ml_shared_cluster"
    notebook_task {
      notebook_path = var.notebook_write
      source        = "GIT"
      base_parameters = {
              input_table_path: "/databricks-datasets/nyctaxi-with-zipcodes/subsampled"
              # TODO: Empty start/end dates will process the whole range. Update this as needed to process recent data.
              input_start_date: ""
              input_end_date: ""
              timestamp_column: "tpep_dropoff_datetime"
              output_table_name: "${var.output_table_catalog}.mlops_tf.trip_dropoff_features"
              features_transform_module: "dropoff_features"
              primary_keys: "zip"

      }

    }
  }
}

  