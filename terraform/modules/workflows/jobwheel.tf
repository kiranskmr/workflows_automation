
variable "job_name_whl" {
  description = "A name for the job."
  type        = string
  default     = "My Job"
}


variable "notebook_filename_whl" {
  description = "File name for the wheel file job"
  type        = string
  default     = "dabdemo_notebook"
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
      whl = "/Volumes/dev/wheel/wheel_volume/data-0.0.1-py3-none-any.whl"

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