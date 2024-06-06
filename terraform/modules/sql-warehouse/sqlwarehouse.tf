variable "env" {
  description = "Sql warehouse env"
  type        = string
}

resource "databricks_sql_endpoint" "tfwarehouse" {
  name                      = "${var.env} TF Endpoint of ${data.databricks_current_user.me.alphanumeric}"
  cluster_size              = "Small"
  max_num_clusters          = 1
  enable_serverless_compute = true

  tags {
    custom_tags {
      key   = "Owner"
      value = data.databricks_current_user.me.alphanumeric
    }
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



output "warehouse_id" {
  description = "The ID of the sql warehouse"
  value       = databricks_sql_endpoint.tfwarehouse.id
}