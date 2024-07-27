resource "databricks_sql_endpoint" "dabwarehouse" {
  name             = "DAB Endpoint of ${data.databricks_current_user.me.alphanumeric}"
  cluster_size     = "Small"
  max_num_clusters = 1
  enable_serverless_compute = true

 tags {
    custom_tags {
      key   = "Owner"
      value = "${data.databricks_current_user.me.alphanumeric}"
    }
  }
}