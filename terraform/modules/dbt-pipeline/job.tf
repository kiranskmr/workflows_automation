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
  default     = "Terraform-Customer Order Details"
}
variable "dbt_catalog" {
  description = "dbt catalog names"
  type        = string
}
variable "dbt_schema" {
  description = "dbt schema name"
  type        = string
  default     = "dbt_tf"
}
variable "dlt_catalog" {
  description = "dlt catalog name"
  type        = string
  default     = "dlt"
}
variable "dlt_schema" {
  description = "dlt schema name"
  type        = string
  default     = "dlt"
}
variable "notebook_subdirectory" {
  description = "folder for file"
  type        = string
  default     = "databricks_notebooks"
}
variable "notebook_filename" {
  description = "file name"
  type        = string
  default     = "Initial_Setup"
}
variable "volume_filename" {
  description = "file name"
  type        = string
  default     = "Volume"
}

variable "security_job" {
  description = "path for security job"
  type        = string
  default     = "Security"
}
variable "cluster_environment_type" {
  description = "Cluster EnvironmentType tag"
  type        = string
  default     = "dev"
}

variable "volume_catalog" {
  description = "Volume catalog"
  type        = string
}

variable "volume_schema" {
  description = "Volume Schema"
  type        = string
  default     = "wine_tf"
}

variable "pii_volume_schema" {
  description = "Volume Schema for pii data"
  type        = string
  default     = "pii_tf"
}


variable "ml_filename" {
  description = "File name for Ml job"
  type        = string
  default     = "machine-learning-with-unity-catalog"
}
variable "generate_data" {
  description = "File name for Ml job"
  type        = string
  default     = "PII/00_generate_data"
}
variable "spark_version" {
  description = "Spark version Ml job"
  type        = string
  default     = "14.2.x-cpu-ml-scala2.12"
}


variable "warehouse_id" {
  description = "Sql warehouse id"
  type        = string
}

variable "pipeline_id" {
  description = "dlt pipeline id"
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

resource "databricks_job" "this" {
  name   = var.job_name
  format = "MULTI_TASK"
  job_cluster {
    new_cluster {
      spark_version = data.databricks_spark_version.latest_lts.id
      node_type_id  = data.databricks_node_type.smallest.id
      custom_tags   = { ResourceClass = "MultiNode" }
      spark_env_vars = {
        PYSPARK_PYTHON = "/databricks/python3/bin/python3"
      }
      num_workers        = 8
      data_security_mode = "USER_ISOLATION"


    }
    job_cluster_key = "tf_shared_cluster"
  }



  git_source {
    url      = "https://github.com/kiranskmr/workflows_automation.git"
    provider = "gitHub"
    branch   = "main"
  }
  task {
    task_key        = "Set-up-UC-Catalog-and-Schema"
    job_cluster_key = "tf_shared_cluster"
    notebook_task {
      notebook_path = "${var.notebook_subdirectory}/${var.notebook_filename}"
      source        = "GIT"
      base_parameters = {
        dbt_catalog       = var.dbt_catalog
        dbt_schema        = var.dbt_schema
        dlt_catalog       = var.dlt_catalog
        dlt_schema        = var.dlt_schema
        volume_schema     = var.volume_schema
        pii_volume_schema = var.pii_volume_schema
      }

    }
  }

  task {
    task_key        = "Assigning-UC-masking-and-filtering-funtions"
    job_cluster_key = "tf_shared_cluster"
    depends_on {
      task_key = "DBT-Ingest-customer-data-and-transformation"
    }
    notebook_task {
      notebook_path = "${var.notebook_subdirectory}/${var.security_job}"
      source        = "GIT"
      base_parameters = {
        dbt_catalog = var.dbt_catalog
        dbt_schema  = var.dbt_schema
        dlt_catalog = var.dlt_catalog
        dlt_schema  = var.dlt_schema
      }

    }
  }

  task {

    task_key        = "DBT-Ingest-customer-data-and-transformation"
    job_cluster_key = "tf_shared_cluster"
    depends_on {
      task_key = "Set-up-UC-Catalog-and-Schema"
    }
    run_if = "ALL_SUCCESS"
    dbt_task {
      commands = [
        "dbt deps",
        "dbt build"
      ]
      project_directory = ""

      warehouse_id = var.warehouse_id
      catalog      = var.dbt_catalog
      schema       = var.dbt_schema

    }
    library {
      pypi {
        package = "dbt-databricks>=1.0.0,<2.0.0"
      }
    }

  }

  task {
    depends_on {
      task_key = "Set-up-UC-Catalog-and-Schema"
    }
    task_key = "DLT-Ingest-customer-data-and-transformation"
    pipeline_task {
      pipeline_id = var.pipeline_id
    }
  }


  task {
    task_key        = "VOLUME-Ingest-Data"
    job_cluster_key = "tf_shared_cluster"
    depends_on {
      task_key = "Set-up-UC-Catalog-and-Schema"
    }
    notebook_task {
      notebook_path = "${var.notebook_subdirectory}/${var.volume_filename}"
      source        = "GIT"
      base_parameters = {
        volume_catalog    = var.volume_catalog
        volume_schema     = var.volume_schema
        pii_volume_schema = var.pii_volume_schema
      }

    }
  }




}
output "job_url" {
  value = databricks_job.this.url
}
