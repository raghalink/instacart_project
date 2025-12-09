{{ config(materialized='view') }}

-- Count products per order
with order_line_counts as (
select
order_id,
count(*) as basket_size
from {{ ref('stg_order_products') }}
group by order_id
)

select
o.order_id,
o.user_id,
o.order_number,
o.order_dow,
o.order_hour_of_day,
coalesce(ol.basket_size, 0) as basket_size
from {{ ref('stg_orders') }} o
left join order_line_counts ol
on o.order_id = ol.order_id

