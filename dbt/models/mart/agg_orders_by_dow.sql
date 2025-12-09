{{ config(materialized='table') }}

select
order_dow as day_of_week,
count(*) as number_of_orders
from {{ ref('stg_orders') }}
group by order_dow
order by day_of_week
