--
======================================================================

-- Create base views 

======================================================================

CREATE SCHEMA IF NOT EXISTS analytics;

-- Base orderline view (orders + order_products)

CREATE OR REPLACE VIEW analytics.v_order_lines
AS
SELECT 
o.order_id,
o.user_id,
o.eval_set,
o.order_number,
o.order_dow,
o.order_hour_of_day,
o.days_since_prior_order,
op.product_id,
op.add_to_cart_order,
op.reordered,
FROM instacart.orders AS o
JOIN instacart.order_products AS op
        ON o.order_id = op.order_id;

-- Test the views and some checks  

SELECT * FROM analytics.v_order_lines
LIMIT 50;


SELECT COUNT(*) FROM analytics.v_order_lines;