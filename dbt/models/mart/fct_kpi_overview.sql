{{ config(materialized='table') }}

select
(select count(distinct user_id) from {{ ref('stg_orders') }}) as total_users,
(select count(*) from {{ ref('stg_orders') }}) as total_orders,
(select count(*) from {{ ref('stg_order_products') }}) as total_order_lines,
(select count(distinct product_id) from {{ ref('stg_products') }}) as distinct_products,
(select round(avg(basket_size)::numeric, 2) from {{ ref('int_order_basket_sizes') }}) as avg_basket_size,
(select round(sum(case when reordered = 1 then 1 else 0 end)::numeric / count(*)::numeric * 100, 2) 
from {{ ref('stg_order_products') }}) as overall_reorder_rate_pct

