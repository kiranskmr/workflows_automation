-- Databricks notebook source
CREATE OR REFRESH LIVE TABLE customers AS SELECT 
    c.customer_key,
    c.customer_name,
    c.customer_address,
    c.nation_key,
    c.customer_phone_number,
    c.customer_account_balance,
    c.customer_market_segment_name
from
    live.base_customer c
order by
    c.customer_key

-- COMMAND ----------

CREATE OR REFRESH LIVE TABLE nations AS SELECT 
    n.nation_key,
    n.nation_name,
    n.region_key
from
    live.base_nation n
order by
    n.nation_key

-- COMMAND ----------

CREATE OR REFRESH LIVE TABLE orders_items AS SELECT 
    monotonically_increasing_id() as order_item_key,
    o.order_key,
    o.order_date,
    o.customer_key,
    o.order_status_code,
    
    l.part_key,
    l.supplier_key,
    l.return_status_code,
    l.order_line_number,
    l.order_line_status_code,
    l.ship_date,
    l.commit_date,
    l.receipt_date,
    l.ship_mode_name,

    l.quantity,
    
    -- extended_price is actually the line item total,
    -- so we back out the extended price per item
    (l.extended_price/nullif(l.quantity, 0)) as base_price,
    l.discount_percentage,
    ((l.extended_price/nullif(l.quantity, 0)) * (1 - l.discount_percentage)) as discounted_price,

    l.extended_price as gross_item_sales_amount,
    (l.extended_price * (1 - l.discount_percentage)) as discounted_item_sales_amount,
    -- We model discounts as negative amounts
    (-1 * l.extended_price * l.discount_percentage) as item_discount_amount,
    l.tax_rate,
    ((l.extended_price + (-1 * l.extended_price * l.discount_percentage)) * l.tax_rate) as item_tax_amount,
    (
        l.extended_price + 
        (-1 * l.extended_price * l.discount_percentage) + 
        ((l.extended_price + (-1 * l.extended_price * l.discount_percentage) * l.tax_rate)
    )) as net_item_sales_amount

from
    live.base_orders o
    join
    live.base_line_item l
        on o.order_key = l.order_key
order by
    o.order_date

-- COMMAND ----------

CREATE OR REFRESH LIVE TABLE orders AS SELECT  
    o.order_key, 
    o.order_date,
    o.customer_key,
    o.order_status_code,
    o.order_priority_code,
    o.order_clerk_name,
    o.shipping_priority,
    o.order_amount
from
    live.base_orders o
order by
    o.order_date

-- COMMAND ----------

CREATE OR REFRESH LIVE TABLE parts_suppliers AS SELECT  

    monotonically_increasing_id() as part_supplier_key,
    p.part_key,
    p.part_name,
    p.part_manufacturer_name,
    p.part_brand_name,
    p.part_type_name,
    p.part_size,
    p.part_container_desc,
    p.retail_price,

    s.supplier_key,
    s.supplier_name,
    s.nation_key,

    ps.supplier_availabe_quantity,
    ps.supplier_cost_amount
from
    live.base_part p
    join
    live.base_part_supplier ps
        on p.part_key = ps.part_key
    join
    live.base_supplier s
        on ps.supplier_key = s.supplier_key
order by
    p.part_key

-- COMMAND ----------

CREATE OR REFRESH LIVE TABLE parts AS SELECT  
    p.part_key,
    p.part_name,
    p.part_manufacturer_name,
    p.part_brand_name,
    p.part_type_name,
    p.part_size,
    p.part_container_desc,
    p.retail_price
from
    live.base_part p
order by
    p.part_key

-- COMMAND ----------

CREATE OR REFRESH LIVE TABLE regions AS SELECT   
    r.region_key,
    r.region_name
from
    live.base_region r
order by
    r.region_key

-- COMMAND ----------

CREATE OR REFRESH LIVE TABLE suppliers AS SELECT    
    s.supplier_key,
    s.supplier_name,
    s.supplier_address,
    s.nation_key,
    s.supplier_phone_number,
    s.supplier_account_balance
from
    live.base_supplier s
order by
    s.supplier_key
