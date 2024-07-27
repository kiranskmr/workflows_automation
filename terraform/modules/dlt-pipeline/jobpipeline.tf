terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}
# Retrieve information about the current user.
data "databricks_current_user" "me" {}

variable "dlt_schema_tf" {
  description = "A catalog for the tf dlt job."
  type        = string
  default     = "dlt_tf"
}
variable "dlt_catalog_tf" {
  description = "A schema for dlt tf job"
  type        = string
  default     = "dev"
}

variable "dlt_pipeline_name" {
  description = "A name for the job"
  type        = string
  default     = "Terraform - Customer Order Details - DLT"
}



resource "databricks_notebook" "dlt_pipeline_notebook_base" {
  source = "${path.module}/../../../databricks_notebooks/DLT-base_tables.sql"
  path   = "${data.databricks_current_user.me.home}/workflows_automation/databricks_notebooks/DLT-base_tables"
}
resource "databricks_notebook" "dlt_pipeline_notebook_ods" {
  source = "${path.module}/../../../databricks_notebooks/DLT-ODS_tables.sql"
  path   = "${data.databricks_current_user.me.home}/workflows_automation/databricks_notebooks/DLT-ODS_tables"
}
resource "databricks_notebook" "dlt_pipeline_notebook_wh" {
  source = "${path.module}/../../../databricks_notebooks/DLT-WH_tables.sql"
  path   = "${data.databricks_current_user.me.home}/workflows_automation/databricks_notebooks/DLT-WH_tables"
}

resource "databricks_pipeline" "this" {
  name    = var.dlt_pipeline_name
  target  = var.dlt_schema_tf
  catalog = var.dlt_catalog_tf


  cluster {
    label = "default"
    autoscale {
      min_workers = 1
      max_workers = 8
      mode        = "ENHANCED"

    }

  }

  library {
    notebook {
      path = databricks_notebook.dlt_pipeline_notebook_ods.id
    }
  }

  library {
    notebook {
      path = databricks_notebook.dlt_pipeline_notebook_base.id
    }
  }
  library {
    notebook {
      path = databricks_notebook.dlt_pipeline_notebook_wh.id
    }
  }

  filters {}

  edition     = "ADVANCED"
  development = true
  continuous  = false
  channel     = "CURRENT"
}



output "pipeline_id" {
  description = "The ID of the DLT pipeline"
  value       = databricks_pipeline.this.id
}