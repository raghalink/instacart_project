{{config(materialized = 'view')}}

SELECT 
order_dow as day_of_week,
count(*) as number_of_orders
from {{ref('stg_orders')}}
group by order_dow
order by order_dow;