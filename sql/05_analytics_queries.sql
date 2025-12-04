-- ===================================================
-- SECTION 1: Sanity & High-Level KPIs
-- ===================================================
-- Q1. Total volume snapshot

-- Total users
SELECT COUNT(DISTINCT orders.user_id)  FROM instacart.orders;

-- Total orders
SELECT COUNT(*) FROM instacart.orders;

-- Total order lines
SELECT COUNT(*) FROM instacart.order_products;

-- Total distinct products
SELECT COUNT(DISTINCT product_id) FROM instacart.products;

-- Q3. Row checks vs expectations

-- How many distinct order_ids in orders vs in order_products?
SELECT 
(SELECT COUNT(*) FROM instacart.orders) AS 
orders_ids_orders,
(SELECT COUNT(DISTINCT order_id) FROM instacart.order_products) AS 
orders_order_products;

--Do they match as expected?

-- ===================================================
-- SECTION 2: Demand Over Time & Volume
-- ===================================================

-- Q4. Orders by day of week
SELECT order_dow AS day_of_week,COUNT(*) AS number_of_orders FROM instacart.orders
GROUP BY order_dow 
ORDER BY order_dow;

-- Q5. Orders by hour
SELECT order_hour_of_day AS hour_of_day,COUNT(*) as number_of_orders FROM instacart.orders
GROUP BY order_hour_of_day 
ORDER BY order_hour_of_day;


-- Q6. Weekly order pattern (by day-of-week and hour)
SELECT order_dow,order_hour_of_day as hour_of_day, COUNT(*) AS number_of_orders
FROM instacart.orders
GROUP BY order_dow, order_hour_of_day
ORDER BY order_dow, hour_of_day

-- ===================================================
-- SECTION 3: Product & Category Performance
-- ===================================================

-- Q8. Top 20 products
WITH product_counts AS (
SELECT 
product_id, COUNT(*) AS order_count
FROM instacart.v_order_lines
GROUP BY product_id)

SELECT pc.product_name,t.order_count FROM instacart.products AS p
JOIN product_counts pc 
ON p.product_id = pc.product_id
ORDER BY order_count DESC
LIMIT 20;

-- Q9. Top departments
WITH department_count AS (
    SELECT
        p.department_id,
        COUNT(*) AS order_count
    FROM instacart.order_products AS op
    JOIN instacart.products AS p
      ON op.product_id = p.product_id
    GROUP BY p.department_id
)
SELECT
    d.department,
    t.order_count
FROM instacart.departments AS d
JOIN department_count t
  ON d.department_id = t.department_id
ORDER BY t.order_count DESC
LIMIT 20;

-- Q10. Top aisles
WITH aisle_count AS (
    SELECT
        p.aisle_id,
        COUNT(*) AS order_count
    FROM instacart.order_products AS op
    JOIN instacart.products AS p
      ON op.product_id = p.product_id
    GROUP BY p.aisle_id
)
SELECT
    a.aisle_id,
    a.aisle,
    t.order_count
FROM instacart.aisles AS a
JOIN aisle_count t
  ON a.aisle_id = t.aisle_id
ORDER BY t.order_count DESC
LIMIT 20;


-- Q11. Product reorder rates
WITH order_reorder_count AS (
    SELECT
        product_id,
        COUNT(*) AS order_count,
        SUM(CASE WHEN reordered = 1 THEN 1 ELSE 0 END) AS reorder_count
    FROM instacart.order_products
    GROUP BY product_id
)
SELECT
    p.product_id,
    p.product_name,
    t.order_count,
    t.reorder_count,
    ROUND( (t.reorder_count::numeric / t.order_count) * 100,2) AS reorder_rate
FROM instacart.products AS p
JOIN order_reorder_count t
  ON p.product_id = t.product_id
ORDER BY reorder_rate DESC
-- LIMIT 20;


-- Q12. Department reorder rates
WITH department_reorder_stats AS (
    SELECT
        p.department_id,
        COUNT(*) AS order_count,
        SUM(CASE WHEN op.reordered = 1 THEN 1 ELSE 0 END) AS reorder_count
    FROM instacart.order_products AS op
    JOIN instacart.products AS p
      ON op.product_id = p.product_id
    GROUP BY p.department_id
)
SELECT
    d.department_id,
    d.department,
    t.order_count,
    t.reorder_count,
    ROUND( (t.reorder_count::numeric / t.order_count) * 100, 2 ) AS reorder_rate_pct
FROM instacart.departments AS d
JOIN department_reorder_stats AS t
  ON d.department_id = t.department_id
ORDER BY reorder_rate_pct DESC
-- LIMIT 20;

-- Q13. aisle reorder rates
WITH aisle_reorder_stats AS (
    SELECT
        p.aisle_id,
        COUNT(*) AS order_count,
        SUM(CASE WHEN op.reordered = 1 THEN 1 ELSE 0 END) AS reorder_count
    FROM instacart.order_products AS op
    JOIN instacart.products AS p
      ON op.product_id = p.product_id
    GROUP BY p.aisle_id
)
SELECT
    a.aisle_id,
    a.aisle,
    t.order_count,
    t.reorder_count,
    ROUND( (t.reorder_count::numeric / t.order_count) * 100, 2 ) AS reorder_rate_pct
FROM instacart.aisles AS a
JOIN aisle_reorder_stats AS t
  ON a.aisle_id = t.aisle_id
ORDER BY reorder_rate_pct DESC;
-- optional: LIMIT 20;


-- ===================================================
-- SECTION 4: Basket & Co-occurrence
-- ===================================================
-- Q13. Average basket size
WITH order_basket_sizes AS (
    SELECT
        order_id,
        COUNT(*) AS basket_size
    FROM instacart.order_products
    GROUP BY order_id
)
SELECT
    ROUND(AVG(t.basket_size)::numeric, 2) AS avg_basket_size
FROM order_basket_sizes AS t;

-- Q14. Basket size by DOW/hour

-- Q15. Product pair co-occurrence

-- ===================================================
-- SECTION 5: User Behavior & Lifecycle
-- ===================================================
-- Q16. Top customers by order count
-- Q17. Time between orders (median per user)
-- Q18. Basket size vs order_number

-- ===================================================
-- SECTION 6: Reorder Dynamics
-- ===================================================
-- Q19. Overall reorder ratio
-- Q20. Next-order inclusion probability for products