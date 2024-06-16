
resource "azuredevops_variable_group" "variable_group" {
  project_id   = azuredevops_project.project.id
  name         = "Devops Automation"
  description  = "Variable Group"
  allow_access = true

   variable {
     name  = "ARM_ACCESS_KEY"
     value = azurerm_storage_account.storage_account.primary_access_key
  }


  variable {
    name = "TEST_CLUSTER_ID"
    value = databricks_cluster.cluster.id
  }

   variable {
    name = "databricks_host"
    value = ""
  }


  variable {
    name = "BUNDLE_VAR_warehouse_id"
    value = databricks_sql_endpoint.dabwarehouse.id
  }
  variable {
    name = "BUNDLE_VAR_node_type"
    value = ""
  }
  
  variable {
    name = "container_name"
    value = azurerm_storage_data_lake_gen2_filesystem.container.name
  }
   variable {
    name = "resource_group_name"
    value = azurerm_resource_group.resource_group.name
  }
    variable {
    name = "storage_account_name"
    value = azurerm_storage_account.storage_account.name
  }

    variable {
    name = "STAGING_AZURE_SP_APPLICATION_ID"
    value = ""
  }

    variable {
    name = "STAGING_AZURE_SP_CLIENT_SECRET"
    value = ""
  }

    variable {
    name = "STAGING_AZURE_SP_TENANT_ID"
    value = ""
  }

    variable {
    name = "PROD_AZURE_SP_TENANT_ID"
    value = ""
  }

    variable {
    name = "PROD_AZURE_SP_CLIENT_SECRET"
    value = ""
  }

    variable {
    name = "PROD_AZURE_SP_APPLICATION_ID"
    value = ""
  }
    variable {
    name = "git_url"
    value = ""
  }
}


