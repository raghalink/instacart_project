-- Create Materialized views

-- Materialized view for product pair concurrence

DROP MATERIALIZED VIEW IF EXISTS 
instacart.mv_product_pair_coocurrence

CREATE MATERIALIZED VIEW 
instacart.mv_product_pair_coocurrence AS
WITH product_pair AS (
    SELECT
        LEAST(a.product_id, b.product_id)    AS product_id_a,
        GREATEST(a.product_id, b.product_id) AS product_id_b,
        COUNT(*) AS order_count
    FROM instacart.order_products AS a
    JOIN instacart.order_products AS b
      ON a.order_id = b.order_id
     AND a.product_id < b.product_id
    GROUP BY
        a.product_id, b.product_id   
)
SELECT
	p1.product_name AS product_a,
	p2.product_name As product_b,
    t.order_count
FROM product_pair AS t
JOIN instacart.products AS p1
ON t.product_id_a = p1.product_id
JOIN instacart.products AS p2
ON t.product_id_b = p2.product_id
ORDER BY order_count DESC
LIMIT 1000;

-- Materialized view for next_order_inlcusion_probability
DROP MATERIALIZED VIEW IF EXISTS 
instacart.mv_next_order_inclusion_probability

WITH user_product_orders as 
( 
SELECT user_id,product_id,order_number
FROM instacart.v_order_lines
),

next_order_match AS (
SELECT a.product_id,
CASE WHEN b.product_id IS NOT NULL 
THEN 1
ELSE 0
END AS bought_next
FROM user_product_orders AS a
LEFT JOIN user_product_orders AS b
ON a.user_id = b.user_id
AND a.product_id = b.product_id
AND a.order_number + 1 = b.order_number
)
SELECT product_id,SUM(bought_next) AS repeat_buys,
COUNT(*) AS total_buys,
ROUND((100 * SUM(bought_next)::numeric)/COUNT(*),2) AS next_order_inclusion_problty
FROM next_order_match 
GROUP BY product_id 
ORDER BY next_order_inclusion_problty DESC
LIMIT 20;