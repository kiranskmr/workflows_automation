
variable "job_name_whl" {
  description = "A name for the job."
  type        = string
  default     = "Terraform-Wheel-File-Dependency"
}

variable "volume_catalog" {
  description = "A name for volume catalog."
  type        = string
}


variable "notebook_filename_whl" {
  description = "File name for the wheel file job"
  type        = string
  default     = "dabdemo_notebook"
}
variable "notebook_subdirectory" {
  description = "folder for file"
  type        = string
  default     = "databricks_notebooks"
}

resource "databricks_job" "whl" {
  name   = var.job_name_whl
  format = "MULTI_TASK"

  git_source {
    url      = "https://github.com/kiranskmr/workflows_automation.git"
    provider = "gitHub"
    branch   = "main"
  }

  task {
    task_key        = "Run-Wheel-File-Dependency"
    job_cluster_key = "tf_job_cluster_wheel"
    notebook_task {
      notebook_path = "${var.notebook_subdirectory}/${var.notebook_filename_whl}"
      source        = "GIT"


    }

    library {
      whl = "/Volumes/${var.volume_catalog}/wheel_dlt/wheel_volume/data-0.0.1-py3-none-any.whl"

    }

  }


  job_cluster {
    new_cluster {
      spark_version = data.databricks_spark_version.latest_lts.id
      node_type_id  = data.databricks_node_type.smallest.id
      custom_tags   = { ResourceClass = "MultiNode" }
      spark_env_vars = {
        PYSPARK_PYTHON = "/databricks/python3/bin/python3"
      }
      num_workers        = 2
      data_security_mode = "SINGLE_USER"

    }

    job_cluster_key = "tf_job_cluster_wheel"
  }

}


terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}
# Retrieve information about the current user.
data "databricks_current_user" "me" {}



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
