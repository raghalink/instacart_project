{{ config(materialized = 'view') }}

SELECT 
aisle_id,
aisles
FROM {{source('instacart','aisles')}}
