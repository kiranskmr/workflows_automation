{{
    config(
        materialized = 'table',
        post_hook=[
        "OPTIMIZE {{ this }} ZORDER BY customer_key;",
        "ANALYZE TABLE {{ this }} COMPUTE STATISTICS FOR ALL COLUMNS;"
        ]
    )
}}
with customers as (

    select * from {{ ref('base_customer') }}

)
select 
    c.customer_key,
    c.customer_name,
    c.customer_address,
    c.nation_key,
    c.customer_phone_number,
    c.customer_account_balance,
    c.customer_market_segment_name
from
    customers c
order by
    c.customer_key