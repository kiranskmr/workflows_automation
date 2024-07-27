# Databricks notebook source

dbt_catalog_value = dbutils.widgets.get("dbt_catalog")
dbt_schema_value = dbutils.widgets.get("dbt_schema")
spark.conf.set("dbt_catalog", dbt_catalog_value)
spark.conf.set("dbt_schema", dbt_schema_value)




# COMMAND ----------

# MAGIC %sql 
# MAGIC CREATE CATALOG IF NOT EXISTS  ${dbt_catalog};
# MAGIC CREATE SCHEMA IF NOT EXISTS  ${dbt_catalog}.${dbt_schema};
# MAGIC
# MAGIC

# COMMAND ----------

# MAGIC %sql
# MAGIC --Create or replace function to redact phone Number
# MAGIC CREATE FUNCTION IF NOT EXISTS ${dbt_catalog}.${dbt_schema}.redact_phone_number(customer_phone_number STRING)
# MAGIC RETURN CASE WHEN
# MAGIC     is_account_group_member('central-bu-team') THEN customer_phone_number  
# MAGIC     ELSE 'REDACTED'
# MAGIC END;
# MAGIC


# COMMAND ----------

# MAGIC %sql
# MAGIC --Create or replace function to redact customer address
# MAGIC CREATE FUNCTION IF NOT EXISTS ${dbt_catalog}.${dbt_schema}.redact_address(customer_address STRING)
# MAGIC RETURN CASE WHEN
# MAGIC     is_account_group_member('hr-team') THEN customer_address  
# MAGIC     ELSE 'REDACTED'
# MAGIC END;
# MAGIC


# COMMAND ----------

# MAGIC %sql
# MAGIC CREATE FUNCTION IF NOT EXISTS ${dbt_catalog}.${dbt_schema}.filter_segment (customer_market_segment_name STRING)
# MAGIC RETURN CASE WHEN
# MAGIC   is_account_group_member('central-bu-team') THEN TRUE
# MAGIC   ELSE customer_market_segment_name = 'AUTOMOBILE'
# MAGIC   -- we support compound filters as well (filter on region AND product columns, for example)
# MAGIC END;


# COMMAND ----------

# MAGIC %sql
# MAGIC ALTER TABLE ${dbt_catalog}.${dbt_schema}.customers ALTER COLUMN customer_phone_number SET MASK ${dbt_catalog}.${dbt_schema}.redact_phone_number;

# COMMAND ----------

# MAGIC %sql
# MAGIC ALTER TABLE ${dbt_catalog}.${dbt_schema}.customers ALTER COLUMN customer_address SET MASK ${dbt_catalog}.${dbt_schema}.redact_address;

# COMMAND ----------

# MAGIC %sql
# MAGIC ALTER TABLE ${dbt_catalog}.${dbt_schema}.customers SET ROW FILTER ${dbt_catalog}.${dbt_schema}.filter_segment ON (customer_market_segment_name); 

