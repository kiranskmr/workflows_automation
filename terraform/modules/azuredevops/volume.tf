resource "databricks_catalog" "catalog_dev" {
  name    = "dev_sanjeev"
  comment = "this catalog is used for dev"
  properties = {
    purpose = "dev env"
  }
}

resource "databricks_catalog" "catalog_test" {
  name    = "test_sanjeev"
  comment = "this catalog is used for test"
  properties = {
    purpose = "test env"
  }
}

resource "databricks_catalog" "catalog_prod" {
  name    = "prod_sanjeev"
  comment = "this catalog is used for prod"
  properties = {
    purpose = "prod env"
  }
}

resource "databricks_schema" "wheel_schema_dev" {
  catalog_name = databricks_catalog.catalog_dev.id
  name         = "wheel"
  comment      = "this database is used for wheel file testing in volumes"
  properties = {
    kind = "various"
  }
}

resource "databricks_schema" "mlops_schema_dev" {
  catalog_name = databricks_catalog.catalog_dev.id
  name         = "mlops"
  comment      = "this database is used for mlops"
  properties = {
    kind = "various"
  }
}

resource "databricks_schema" "wheel_schema_dev_tf" {
  catalog_name = databricks_catalog.catalog_dev.id
  name         = "wheel_tf"
  comment      = "this database is used for wheel file testing in volumes"
  properties = {
    kind = "various"
  }
}

resource "databricks_schema" "mlops_schema_dev_tf" {
  catalog_name = databricks_catalog.catalog_dev.id
  name         = "mlops_tf"
  comment      = "this database is used for mlops"
  properties = {
    kind = "various"
  }
}

resource "databricks_schema" "wheel_schema_test" {
  catalog_name = databricks_catalog.catalog_test.id
  name         = "wheel"
  comment      = "this database is used for wheel file testing in volumes"
  properties = {
    kind = "various"
  }
}

resource "databricks_schema" "mlops_schema_test" {
  catalog_name = databricks_catalog.catalog_test.id
  name         = "mlops"
  comment      = "this database is used for mlops"
  properties = {
    kind = "various"
  }
}

resource "databricks_schema" "wheel_schema_test_tf" {
  catalog_name = databricks_catalog.catalog_test.id
  name         = "wheel_tf"
  comment      = "this database is used for wheel file testing in volumes"
  properties = {
    kind = "various"
  }
}

resource "databricks_schema" "mlops_schema_test_tf" {
  catalog_name = databricks_catalog.catalog_test.id
  name         = "mlops_tf"
  comment      = "this database is used for mlops"
  properties = {
    kind = "various"
  }
}

resource "databricks_schema" "wheel_schema_prod" {
  catalog_name = databricks_catalog.catalog_prod.id
  name         = "wheel"
  comment      = "this database is used for wheel file testing in volumes"
  properties = {
    kind = "various"
  }
}

resource "databricks_schema" "mlops_schema_prod" {
  catalog_name = databricks_catalog.catalog_prod.id
  name         = "mlops"
  comment      = "this database is used for mlops"
  properties = {
    kind = "various"
  }
}

resource "databricks_schema" "wheel_schema_prod_tf" {
  catalog_name = databricks_catalog.catalog_prod.id
  name         = "wheel_tf"
  comment      = "this database is used for wheel file testing in volumes"
  properties = {
    kind = "various"
  }
}

resource "databricks_schema" "mlops_schema_prod_tf" {
  catalog_name = databricks_catalog.catalog_prod.id
  name         = "mlops_tf"
  comment      = "this database is used for mlops"
  properties = {
    kind = "various"
  }
}


resource "databricks_volume" "volume_dev" {
  name             = "wheel_volume"
  catalog_name     = databricks_catalog.catalog_dev.name
  schema_name      = databricks_schema.wheel_schema_dev.name
  volume_type      = "MANAGED"
  comment          = "this volume is used for wheel file testing in volumes"
}

resource "databricks_volume" "volume_test" {
  name             = "wheel_volume"
  catalog_name     = databricks_catalog.catalog_test.name
  schema_name      = databricks_schema.wheel_schema_test.name
  volume_type      = "MANAGED"
  comment          = "this volume is used for wheel file testing in volumes"
}

resource "databricks_volume" "volume_prod" {
  name             = "wheel_volume"
  catalog_name     = databricks_catalog.catalog_prod.name
  schema_name      = databricks_schema.wheel_schema_prod.name
  volume_type      = "MANAGED"
  comment          = "this volume is used for wheel file testing in volumes"
}

resource "databricks_volume" "volume_dev_tf" {
  name             = "wheel_volume"
  catalog_name     = databricks_catalog.catalog_dev.name
  schema_name      = databricks_schema.wheel_schema_dev_tf.name
  volume_type      = "MANAGED"
  comment          = "this volume is used for wheel file testing in volumes"
}

resource "databricks_volume" "volume_test_tf" {
  name             = "wheel_volume"
  catalog_name     = databricks_catalog.catalog_test.name
  schema_name      = databricks_schema.wheel_schema_test_tf.name
  volume_type      = "MANAGED"
  comment          = "this volume is used for wheel file testing in volumes"
}

resource "databricks_volume" "volume_prod_tf" {
  name             = "wheel_volume"
  catalog_name     = databricks_catalog.catalog_prod.name
  schema_name      = databricks_schema.wheel_schema_prod_tf.name
  volume_type      = "MANAGED"
  comment          = "this volume is used for wheel file testing in volumes"
}