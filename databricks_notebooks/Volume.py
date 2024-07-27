# Databricks notebook source
volume_catalog_value = dbutils.widgets.get("volume_catalog")
volume_schema_value = dbutils.widgets.get("volume_schema")
pii_volume_schema_value = dbutils.widgets.get("pii_volume_schema")


spark.conf.set("volume_catalog", volume_catalog_value)
spark.conf.set("volume_schema", volume_schema_value)
spark.conf.set("pii_volume_schema", pii_volume_schema_value)

# COMMAND ----------

# MAGIC %sql 
# MAGIC CREATE SCHEMA IF NOT EXISTS  ${volume_catalog}.${volume_schema};
# MAGIC CREATE SCHEMA IF NOT EXISTS  ${volume_catalog}.${pii_volume_schema};

# COMMAND ----------

# MAGIC %sql 
# MAGIC create volume if not exists ${volume_catalog}.${volume_schema}.wine_data;
# MAGIC create volume if not exists ${volume_catalog}.${pii_volume_schema}.pii_dataset;


# COMMAND ----------

if "winequality-red.csv" not in [file.name for file in dbutils.fs.ls("dbfs:/Volumes/"+volume_catalog_value +"/"+volume_schema_value+"/wine_data/")]:
    dbutils.fs.cp("dbfs:/databricks-datasets/wine-quality/winequality-red.csv", "dbfs:/Volumes/"+volume_catalog_value +"/"+volume_schema_value+"/wine_data/")

# COMMAND ----------

if "winequality-white.csv" not in [file.name for file in dbutils.fs.ls("dbfs:/Volumes/"+volume_catalog_value +"/"+volume_schema_value+"/wine_data/")]:
    dbutils.fs.cp("dbfs:/databricks-datasets/wine-quality/winequality-white.csv", "dbfs:/Volumes/"+volume_catalog_value +"/"+volume_schema_value+"/wine_data/")

# COMMAND ----------

# This example uses publicly-available data that we clean up and copy to Unity Catalog so that others can use the same dataset

# Read the data from CSV files
white_wine = spark.read.csv("dbfs:/Volumes/"+volume_catalog_value +"/"+volume_schema_value+"/wine_data/winequality-white.csv", sep=';', header=True)
red_wine = spark.read.csv("dbfs:/Volumes/"+volume_catalog_value +"/"+volume_schema_value+"/wine_data/winequality-red.csv", sep=';', header=True)

# To clean up the data, remove the spaces from the column names, since parquet doesn't allow them
for c in white_wine.columns:
    white_wine = white_wine.withColumnRenamed(c, c.replace(" ", "_"))
for c in red_wine.columns:
    red_wine = red_wine.withColumnRenamed(c, c.replace(" ", "_"))




# COMMAND ----------

# MAGIC %sql
# MAGIC drop table if exists ${volume_catalog}.${volume_schema}.white_wine;
# MAGIC drop table if exists ${volume_catalog}.${volume_schema}.red_wine;

# COMMAND ----------

white_wine.write.saveAsTable(volume_catalog_value +"."+volume_schema_value+".white_wine")
red_wine.write.saveAsTable(volume_catalog_value +"."+volume_schema_value+".red_wine")
