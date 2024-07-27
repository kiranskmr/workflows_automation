data "databricks_node_type" "smallest" {
  local_disk = true
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_cluster" "cluster" {
  cluster_name            = "Cluster of ${data.databricks_current_user.me.alphanumeric}"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20
  data_security_mode = "USER_ISOLATION"
  autoscale {
    min_workers = 1
    max_workers = 50
  }
}