
-- Metric views for Instacart project (schema: instacart)
--   - Base tables in instacart schema
--   - 05_analytics_queries
--   - Views:
--       instacart.v_order_lines
--       instacart.v_order_basket_sizes
--     already created by 04_views.sql


/* =========================================================
   1. OVERVIEW KPI VIEW (single-row snapshot)
   ========================================================= */
CREATE OR REPLACE VIEW instacart.v_kpi_overview AS
SELECT
    -- Total distinct users
    (SELECT COUNT(DISTINCT o.user_id)
     FROM instacart.orders AS o) AS total_users,

    -- Total orders
    (SELECT COUNT(*)
     FROM instacart.orders) AS total_orders,

    -- Total order lines
    (SELECT COUNT(*)
     FROM instacart.order_products) AS total_order_lines,

    -- Total distinct products (from products table)
    (SELECT COUNT(DISTINCT product_id)
     FROM instacart.products) AS distinct_products,

    -- Average basket size (items per order)
    (SELECT ROUND(AVG(basket_size)::numeric, 2)
     FROM instacart.v_order_basket_sizes) AS avg_basket_size,

    -- Overall reorder rate (% of order lines where reordered = TRUE)
    (SELECT ROUND(SUM(CASE WHEN reordered = 1 THEN 1 ELSE 0 END)::numeric/ COUNT(*)::numeric,4)
     FROM instacart.order_products) AS overall_reorder_rate_pct;

-- test view
SELECT * from instacart.v_orders_by_dow;

/* =========================================================
   2. DEMAND OVER TIME
   ========================================================= */

-- Q4. Orders by day of week
CREATE OR REPLACE VIEW instacart.v_orders_by_dow AS
SELECT 
order_dow AS day_of_week,
COUNT(*)AS number_of_orders
FROM instacart.orders
GROUP BY order_dow
ORDER BY order_dow;

-- test view
SELECT * from instacart.v_orders_by_dow;

-- Q5. Orders by hour
CREATE OR REPLACE VIEW instacart.v_orders_by_hour AS
SELECT order_hour_of_day AS hour_of_day,COUNT(*) AS number_of_orders
FROM instacart.orders
GROUP BY order_hour_of_day
ORDER BY order_hour_of_day;

--test view
SELECT * FROM instacart.v_orders_by_hour;


-- Q6. Weekly pattern: day-of-week x hour
CREATE OR REPLACE VIEW instacart.v_orders_dow_hour AS
SELECT order_dow,
order_hour_of_day AS hour_of_day,
COUNT(*) AS number_of_orders
FROM instacart.orders
GROUP BY order_dow, order_hour_of_day
ORDER BY order_dow, hour_of_day;

--test view 
SELECT * FROM instacart.v_orders_dow_hour;

/* =========================================================
   3. PRODUCT & CATEGORY PERFORMANCE
   ========================================================= */

-- Product-level metrics (order_count, reorder_count, reorder_rate_pct)
-- (based on reorder rates logic)
CREATE OR REPLACE VIEW instacart.v_product_metrics AS
WITH order_reorder_count AS (
SELECT
product_id,
COUNT(*) AS order_count,
SUM(CASE WHEN reordered = 1 THEN 1 ELSE 0 END) AS reorder_count
FROM instacart.order_products
GROUP BY product_id)
SELECT
p.product_id,
p.product_name,
t.order_count,
t.reorder_count,
ROUND((t.reorder_count::numeric / t.order_count) * 100,2) AS reorder_rate_pct
FROM instacart.products AS p
JOIN order_reorder_count AS t
ON p.product_id = t.product_id
;

--test view
SELECT * FROM instacart.v_product_metrics;
-- Department-level metrics (order_count, reorder_count, reorder_rate_pct)
-- (Q9 + Q12 merged)

CREATE OR REPLACE VIEW instacart.v_department_metrics AS
WITH department_stats AS (
SELECT
p.department_id,
COUNT(*) AS order_count,
SUM(CASE WHEN op.reordered = 1 THEN 1 ELSE 0 END) AS reorder_count
FROM instacart.order_products AS op
JOIN instacart.products AS p
ON op.product_id = p.product_id
GROUP BY p.department_id)
SELECT
d.department_id,
d.department,
t.order_count,
t.reorder_count,
ROUND((t.reorder_count::numeric / t.order_count) * 100,2) AS reorder_rate_pct
FROM instacart.departments AS d
JOIN department_stats AS t
ON d.department_id = t.department_id;

SELECT * FROM instacart.v_department_metrics


-- Aisle-level metrics (order_count, reorder_count, reorder_rate_pct)
-- (Q10 + Q13 merged)

CREATE OR REPLACE VIEW instacart.v_aisle_metrics AS
WITH aisle_stats AS (
SELECT
p.aisle_id,
COUNT(*) AS order_count,
SUM(CASE WHEN op.reordered = 1 THEN 1 ELSE 0 END) AS reorder_count
FROM instacart.order_products AS op
JOIN instacart.products AS p
ON op.product_id = p.product_id
GROUP BY p.aisle_id)
SELECT
a.aisle_id,
a.aisle,
t.order_count,
t.reorder_count,
ROUND((t.reorder_count::numeric / t.order_count) * 100,2) AS reorder_rate_pct
FROM instacart.aisles AS a
JOIN aisle_stats AS t
ON a.aisle_id = t.aisle_id;

-- test view 
SELECT * FROM instacart.v_aisle_metrics;


/* =========================================================
   4. BASKET & CO-OCCURRENCE
   ========================================================= */

-- Q13. Average basket size (single-row, but kept as a view for conveniencE9
CREATE OR REPLACE VIEW instacart.v_avg_basket_size AS
SELECT
    ROUND(AVG(basket_size)::numeric, 2) AS avg_basket_size
FROM instacart.v_order_basket_sizes;


-- Q14. Basket size by DOW
CREATE OR REPLACE VIEW instacart.v_basket_size_by_dow AS
WITH order_basket_sizes AS (
SELECT * FROM instacart.v_order_basket_sizes
)
SELECT
o.order_dow,ROUND(AVG(t.basket_size)::numeric, 2) AS avg_basket_size
FROM instacart.orders AS o
JOIN order_basket_sizes AS t
ON o.order_id = t.order_id
GROUP BY o.order_dow
ORDER BY o.order_dow;

-- test view 
-- SELECT * FROM instacart.v_basket_size_by_dow;


-- Q14. Basket size by hour_of_day
CREATE OR REPLACE VIEW instacart.v_basket_size_by_hour AS
WITH order_basket_sizes AS (
SELECT *
FROM instacart.v_order_basket_sizes)

SELECT
o.order_hour_of_day,
ROUND(AVG(t.basket_size)::numeric, 2) AS avg_basket_size
FROM instacart.orders AS o
JOIN order_basket_sizes AS t
ON o.order_id = t.order_id
GROUP BY o.order_hour_of_day
ORDER BY o.order_hour_of_day;

-- test view 
-- SELECT * FROM instacart.v_basket_size_by_hour;

-- Q15. Product pair co-occurrence (by product_id and names) 
CREATE OR REPLACE VIEW instacart.v_product_pair_cooccurrence AS
SELECT * FROM instacart.mv_product_coocurrence;

-- test view 
-- SELECT * FROM instacart.v_product_pair_cooccurrence;

/* =========================================================
   5. USER BEHAVIOR & LIFECYCLE
   ========================================================= */

-- Q16. User-level order count (top customers logic without LIMIT)
CREATE OR REPLACE VIEW instacart.v_user_order_counts AS
SELECT user_id,
COUNT(*) AS order_count
FROM instacart.orders
GROUP BY user_id
ORDER BY order_count DESC;
-- test view 
-- SELECT * FROM instacart.v_user_order_counts;

-- Q17. Time between orders (median per user)
CREATE OR REPLACE VIEW instacart.v_user_median_order_gap AS
SELECT
user_id,
percentile_disc(0.5) WITHIN GROUP (ORDER BY days_since_prior_order) AS median_days_between_orders
FROM instacart.orders
WHERE days_since_prior_order IS NOT NULL
GROUP BY user_id
ORDER BY median_days_between_orders DESC;

-- test view 
-- SELECT * FROM instacart.v_user_median_order_gap;

-- Q18. Basket size vs order_number (lifecycle KPI)
CREATE OR REPLACE VIEW instacart.v_lifecycle_basket_size AS
SELECT
o.order_number,
ROUND(AVG(v.basket_size)::numeric, 2) AS avg_basket_size
FROM instacart.orders AS o
JOIN instacart.v_order_basket_sizes AS v
ON o.order_id = v.order_id
GROUP BY o.order_number
ORDER BY o.order_number ASC;
-- test view 
-- SELECT * FROM instacart.v_lifecycle_basket_size;


/* =========================================================
   6. REORDER DYNAMICS
   ========================================================= */

-- Q19. Overall reorder rate as its own view (single-row)
CREATE OR REPLACE VIEW instacart.v_overall_reorder_rate AS
SELECT
ROUND(100.0 * SUM(CASE WHEN reordered = 1 THEN 1 ELSE 0 END)::numeric/ COUNT(*),2) AS overall_reorder_rate_pct
FROM instacart.order_products;

-- test view 
-- SELECT * FROM instacart.v_overall_reorder_rate;

-- Q20. Next-order inclusion probability (per product)
CREATE OR REPLACE VIEW instacart.v_next_order_inclusion_probability AS
SELECT * FROM instacart.v_next_order_inclusion_probability;

-- test view 
-- SELECT * FROM instacart.v_next_order_inclusion_probability;