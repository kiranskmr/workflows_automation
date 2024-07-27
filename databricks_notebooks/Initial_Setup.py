# Databricks notebook source
dlt_catalog_value = dbutils.widgets.get("dlt_catalog")
dlt_schema_value = dbutils.widgets.get("dlt_schema")
spark.conf.set("dlt_catalog", dlt_catalog_value)
spark.conf.set("dlt_schema", dlt_schema_value)
dbt_catalog_value = dbutils.widgets.get("dbt_catalog")
dbt_schema_value = dbutils.widgets.get("dbt_schema")
spark.conf.set("dbt_catalog", dbt_catalog_value)
spark.conf.set("dbt_schema", dbt_schema_value)



volume_schema_value = dbutils.widgets.get("volume_schema")
spark.conf.set("volume_schema", volume_schema_value)
pii_volume_schema_value = dbutils.widgets.get("pii_volume_schema")
spark.conf.set("pii_volume_schema", pii_volume_schema_value)


# COMMAND ----------

# MAGIC %sql 
# MAGIC CREATE CATALOG IF NOT EXISTS  ${dbt_catalog};
# MAGIC CREATE SCHEMA IF NOT EXISTS  ${dbt_catalog}.${dbt_schema};
# MAGIC CREATE CATALOG IF NOT EXISTS  ${dlt_catalog};
# MAGIC CREATE SCHEMA IF NOT EXISTS  ${dlt_catalog}.${dlt_schema};
# MAGIC CREATE SCHEMA IF NOT EXISTS  ${dbt_catalog}.${volume_schema};
