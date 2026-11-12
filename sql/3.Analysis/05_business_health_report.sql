-- ==========================================
-- Business Health Report
-- Purpose : Understand overall business performance
-- ==========================================


-- ==================================================
-- KPI 1: Total Revenue
-- Purpose: Calculate the total revenue generated from delivered orders.
-- ==================================================

SELECT
    SUM(oi.price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- Output:
-- Total Revenue = 13,221,498.11

-- Interpretation:
-- Total revenue is calculated using only delivered orders.
-- This represents the total value of products successfully sold.
-- It serves as the baseline business metric for further revenue analysis.



-- ==================================================
-- KPI 2: Total Delivered Orders
-- Purpose: Count the total number of successfully completed orders.
-- ==================================================

SELECT
    COUNT(*) AS total_orders
FROM orders
WHERE order_status = 'delivered';

-- Output:
-- Total Orders = 96,478

-- Interpretation:
-- This shows the total number of completed customer orders.
-- It represents the transaction volume of the marketplace.
-- Comparing this metric with customer count helps understand repeat purchases.



-- ==================================================
-- KPI 3: Average Order Value (AOV)
-- Purpose: Calculate the average revenue generated per delivered order.
-- ==================================================

WITH delivered_revenue AS (

    SELECT
        SUM(oi.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'

),

delivered_orders AS (

    SELECT
        COUNT(*) AS total_orders
    FROM orders
    WHERE order_status = 'delivered'

)

SELECT
    ROUND(total_revenue / total_orders, 2) AS average_order_value
FROM delivered_revenue
CROSS JOIN delivered_orders;

-- Output:
-- Average Order Value = 137.04

-- Interpretation:
-- On average, each delivered order generated 137.04 in product revenue.
-- This metric provides a baseline for analyzing customer spending behavior.
-- It can later be compared across product categories, customer segments,
-- geographic regions, and seasonal trends.



-- ==================================================
-- KPI 4: Total Customers
-- Purpose: Count the number of unique customers who completed at least
-- one delivered order.
-- ==================================================

SELECT
    COUNT(DISTINCT c.customer_unique_id) AS total_customers
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered';

-- Output:
-- Total Customers = 93,358

-- Interpretation:
-- This represents the number of unique customers who made at least
-- one successful purchase.
-- Comparing this value with Total Orders provides an initial indication
-- of repeat purchasing behaviour.



-- ==================================================
-- KPI 5: Active Sellers
-- Purpose: Count sellers who fulfilled at least one delivered order.
-- ==================================================

SELECT
    COUNT(DISTINCT oi.seller_id) AS active_sellers
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- Output:
-- Active Sellers = 2,970

-- Interpretation:
-- This shows the number of sellers actively contributing to marketplace sales.
-- Future analysis will determine whether revenue is evenly distributed
-- or concentrated among a smaller group of sellers.



-- ==================================================
-- KPI 6: Products Sold
-- Purpose: Count the total number of products sold in delivered orders.
-- ==================================================

SELECT
    COUNT(*) AS total_products_sold
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- Output:
-- Products Sold = 110,197

-- Interpretation:
-- Each row in the order_items table represents one product purchased.
-- This KPI measures the overall sales volume of the marketplace and
-- complements revenue and order count.



-- ==================================================
-- KPI 7: Average Delivery Time
-- Purpose: Calculate the average number of days taken to deliver an order.
-- ==================================================

SELECT
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date -
                    order_purchase_timestamp
                )
            ) / 86400
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL;

-- Output:
-- Average Delivery Time = 12.56 Days

-- Interpretation:
-- This measures the average time taken to deliver completed orders.
-- Delivery performance has a direct impact on customer satisfaction
-- and overall shopping experience.



-- ==================================================
-- KPI 8: Average Review Score
-- Purpose: Calculate the average customer review score for delivered orders.
-- ==================================================

SELECT
    ROUND(AVG(r.review_score), 1) AS average_review_score
FROM reviews r
JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- Output:
-- Average Review Score = 4.2 / 5

-- Interpretation:
-- This KPI represents the overall customer satisfaction level.
-- Future analysis will investigate the factors influencing
-- positive and negative customer reviews.