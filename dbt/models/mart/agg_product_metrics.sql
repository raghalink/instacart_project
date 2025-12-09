{{ config(materialized='table') }}

select
p.product_id,
p.product_name,
count(op.order_id) as order_count,
sum(case when op.reordered = 1 then 1 else 0 end) as reorder_count,
round(sum(case when op.reordered = 1 then 1 else 0 end)::numeric/ count(op.order_id)::numeric * 100,2) as reorder_rate_pct
from {{ ref('stg_order_products') }} op
join {{ ref('stg_products') }} p
on op.product_id = p.product_id
group by p.product_id, p.product_name
order by order_count desc
