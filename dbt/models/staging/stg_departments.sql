{{ config(materialized = 'view')}}

SELECT 
departmnt_id,
departments
FROM {{ source('instacart','departments')}}