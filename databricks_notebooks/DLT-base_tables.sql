-- Databricks notebook source
CREATE OR REFRESH TEMPORARY LIVE TABLE base_customer AS SELECT
  c_custkey as customer_key,
    c_name as customer_name,
    c_address as customer_address,
    c_nationkey as nation_key,
    c_phone as customer_phone_number,
    c_acctbal  as customer_account_balance,
    c_mktsegment as customer_market_segment_name,
    c_comment as customer_comment
FROM samples.tpch.customer;

-- COMMAND ----------

CREATE OR REFRESH TEMPORARY LIVE TABLE base_line_item AS SELECT
   l_orderkey as order_key,
    l_partkey as part_key,
    l_suppkey as supplier_key,
    l_linenumber as order_line_number,
    l_quantity as quantity,
    l_extendedprice as extended_price,
    l_discount as discount_percentage,
    l_tax as tax_rate,
    l_returnflag as return_status_code,
    l_linestatus as order_line_status_code,
    l_shipdate as ship_date,
    l_commitdate as commit_date,
    l_receiptdate as receipt_date,
    l_shipinstruct as ship_instructions_desc,
    l_shipmode as ship_mode_name,
    l_comment as order_line_comment
FROM samples.tpch.lineitem;

-- COMMAND ----------

CREATE OR REFRESH TEMPORARY LIVE TABLE base_nation AS SELECT
    n_nationkey as nation_key,
    n_name as nation_name,
    n_regionkey as region_key,
    n_comment as nation_comment
FROM samples.tpch.nation;

-- COMMAND ----------

CREATE OR REFRESH TEMPORARY LIVE TABLE base_orders AS SELECT
    o_orderkey as order_key, 
    o_custkey as customer_key,
    o_orderstatus as order_status_code,
    o_totalprice as order_amount,
    o_orderdate as order_date,
    o_orderpriority as order_priority_code,
    o_clerk as order_clerk_name,
    o_shippriority as shipping_priority,
    o_comment as order_comment
FROM samples.tpch.orders;

-- COMMAND ----------

CREATE OR REFRESH TEMPORARY LIVE TABLE base_part_supplier AS SELECT
    ps_partkey as part_key,
    ps_suppkey as supplier_key,
    ps_availqty as supplier_availabe_quantity,
    ps_supplycost as supplier_cost_amount,
    ps_comment as part_supplier_comment
FROM samples.tpch.partsupp;

-- COMMAND ----------

CREATE OR REFRESH TEMPORARY LIVE TABLE base_part AS SELECT
   p_partkey as part_key,
    p_name as part_name,
    p_mfgr as part_manufacturer_name,
    p_brand as part_brand_name,
    p_type as part_type_name,
    p_size as part_size,
    p_container as part_container_desc,
    p_retailprice as retail_price,
    p_comment as part_comment
FROM samples.tpch.part;

-- COMMAND ----------

CREATE OR REFRESH TEMPORARY LIVE TABLE base_region AS SELECT
   r_regionkey as region_key,
    r_name as region_name,
    r_comment as region_comment
FROM samples.tpch.region;

-- COMMAND ----------

CREATE OR REFRESH TEMPORARY LIVE TABLE base_supplier AS SELECT
    s_suppkey as supplier_key,
    s_name as supplier_name,
    s_address as supplier_address,
    s_nationkey as nation_key,
    s_phone as supplier_phone_number,
    s_acctbal as supplier_account_balance,
    s_comment as supplier_comment
FROM samples.tpch.supplier;
