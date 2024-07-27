-- Databricks notebook source
CREATE OR REFRESH LIVE TABLE dim_customer AS SELECT 
 
        c.customer_key,
        c.customer_name,
        c.customer_address,
        n.nation_key as customer_nation_key,
        n.nation_name as customer_nation_name,
        r.region_key as customer_region_key,
        r.region_name as customer_region_name,
        c.customer_phone_number,
        c.customer_account_balance,
        c.customer_market_segment_name
    from
        live.customers c
        join
        live.nations n
            on c.nation_key = n.nation_key
        join
        live.regions r
            on n.region_key = r.region_key
order by
    c.customer_key


-- COMMAND ----------

CREATE OR REFRESH LIVE TABLE dim_part_supplier_xrf AS SELECT 

        ps.part_supplier_key,

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
        supplier_address,
        s.supplier_phone_number,
        s.supplier_account_balance,
        n.nation_key as supplier_nation_key,
        n.nation_name as supplier_nation_name,
        r.region_key as supplier_region_key,
        r.region_name as supplier_region_name,

        ps.supplier_availabe_quantity,
        ps.supplier_cost_amount
    from
        live.parts p
        join
        live.parts_suppliers ps
            on p.part_key = ps.part_key
        join
        live.suppliers s
            on ps.supplier_key = s.supplier_key
        join
        live.nations n
            on s.nation_key = n.nation_key
        join
        live.regions r
            on n.region_key = r.region_key
order by
    p.part_key,
    s.supplier_key

-- COMMAND ----------

CREATE OR REFRESH LIVE TABLE dim_part AS SELECT  
        p.part_key,
        p.part_name,
        p.part_manufacturer_name,
        p.part_brand_name,
        p.part_type_name,
        p.part_size,
        p.part_container_desc,
        p.retail_price
    from
        live.parts p
order by
    p.part_key

-- COMMAND ----------

CREATE OR REFRESH LIVE TABLE dim_supplier AS SELECT  
        s.supplier_key,
        s.supplier_name,
        s.supplier_address,
        n.nation_key as supplier_nation_key,
        n.nation_name as supplier_nation_name,
        r.region_key as supplier_region_key,
        r.region_name as supplier_region_name,
        s.supplier_phone_number,
        s.supplier_account_balance
    from
        live.suppliers s
        join
        live.nations n
            on s.nation_key = n.nation_key
        join
        live.regions r
            on n.region_key = r.region_key
order by
    s.supplier_key

-- COMMAND ----------

CREATE OR REFRESH LIVE TABLE fct_orders_items AS SELECT  
        o.order_item_key,
        o.order_key,
        o.order_date,
        o.customer_key,
        o.order_status_code,
        
        o.part_key,
        o.supplier_key,
        o.return_status_code,
        o.order_line_number,
        o.order_line_status_code,
        o.ship_date,
        o.commit_date,
        o.receipt_date,
        o.ship_mode_name,
        ps.supplier_cost_amount,
        ps.retail_price,
        o.base_price,
        o.discount_percentage,
        o.discounted_price,
        o.tax_rate,
        
        1 as order_item_count,
        o.quantity,

        o.gross_item_sales_amount,
        o.discounted_item_sales_amount,
        o.item_discount_amount,
        o.item_tax_amount,
        o.net_item_sales_amount

    from
        live.orders_items o
        join
        live.parts_suppliers ps
            on o.part_key = ps.part_key and
                o.supplier_key = ps.supplier_key
order by
    o.order_date

-- COMMAND ----------

CREATE OR REFRESH TEMPORARY LIVE TABLE order_item_summary AS SELECT  

        o.order_key,
        sum(o.gross_item_sales_amount) as gross_item_sales_amount,
        sum(o.item_discount_amount) as item_discount_amount,
        sum(o.item_tax_amount) as item_tax_amount,
        sum(o.net_item_sales_amount) as net_item_sales_amount
    from live.orders_items o
    group by
        1 

-- COMMAND ----------

CREATE OR REFRESH  LIVE TABLE fct_orders AS SELECT  
        o.order_key, 
        o.order_date,
        o.customer_key,
        o.order_status_code,
        o.order_priority_code,
        o.order_clerk_name,
        o.shipping_priority,
                
        1 as order_count,                
        s.gross_item_sales_amount,
        s.item_discount_amount,
        s.item_tax_amount,
        s.net_item_sales_amount
    from
        live.orders o
        join
        live.order_item_summary s
            on o.order_key = s.order_key
order by
    o.order_date


-- COMMAND ----------

CREATE OR REFRESH  TEMPORARY LIVE TABLE rpt_minimum_cost_suppliers_tmp AS SELECT  
        s.supplier_account_balance,
        s.supplier_name,
        s.supplier_nation_key,
        s.supplier_region_key,
        s.supplier_nation_name,
        s.supplier_region_name,
        s.part_key,
        s.part_manufacturer_name,
        s.part_size,
        s.part_type_name,
        s.supplier_cost_amount,
        s.supplier_address,
        s.supplier_phone_number,
        rank() over(partition by s.supplier_region_key, s.part_key order by s.supplier_cost_amount) as supplier_cost_rank,
        row_number() over(partition by s.supplier_region_key, s.part_key, s.supplier_cost_amount order by s.supplier_account_balance desc) as supplier_rank
    from
      live.dim_part_supplier_xrf s


-- COMMAND ----------

CREATE OR REFRESH  LIVE TABLE rpt_minimum_cost_suppliers AS SELECT  
    *
from
    live.rpt_minimum_cost_suppliers_tmp  s
where
    s.supplier_cost_rank = 1 and 
    s.supplier_rank <= 100
order by 
    s.supplier_name, s.part_key


-- COMMAND ----------

CREATE OR REFRESH  LIVE TABLE rpt_pricing_summary AS SELECT  
    f.return_status_code,
    f.order_line_status_code,
    sum(f.quantity) as quantity,
    sum(f.gross_item_sales_amount) as gross_item_sales_amount,
    sum(f.discounted_item_sales_amount) as discounted_item_sales_amount,
    sum(f.net_item_sales_amount) as net_item_sales_amount,

    avg(f.quantity) as avg_quantity,
    avg(f.base_price) as avg_base_price,
    avg(f.discount_percentage) as avg_discount_percentage,

    sum(f.order_item_count) as order_item_count
    
from
    live.fct_orders_items f
where
    f.ship_date <= dateadd('day', -90)
group by
    1,2

