WITH one_time_customers AS(
    SELECT customer_unique_id
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY customer_unique_id
    HAVING COUNT(DISTINCT(o.order_id)) = 1
)
SELECT COUNT(*) AS one_time_customers
FROM one_time_customers;

--OUTPUT: 90,557 customers have exactly 1 delivered order.
---------------------------------------------------------------

WITH repeat_customers AS(
    SELECT customer_unique_id
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY customer_unique_id
    HAVING COUNT(DISTINCT(o.order_id)) > 1
)
SELECT COUNT(*) AS repeat_customers
FROM repeat_customers;
-- OUTPUT: 2801 customers have more than 1 delivered order.
---------------------------------------------------------------

SELECT c.customer_unique_id, o.order_id, r.review_score
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN reviews AS r
    ON r.order_id = o.order_id;

SELECT c.customer_unique_id, o.order_id, r.review_score
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN reviews AS r
    ON r.order_id = o.order_id
WHERE o.order_status = 'delivered';

--------------------------------------------------------------------
-- when order with same timestamp are retained
WITH purchase_calc AS(
    SELECT
        c.customer_unique_id AS customer_unique_id, 
        o.order_purchase_timestamp AS timestamp,
        o.order_id AS order_id,
        DENSE_RANK() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC) AS purchase,
        COUNT(*) OVER (
            PARTITION BY c.customer_unique_id) AS purchase_count 
    FROM customers AS c
    INNER JOIN orders AS o 
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, o.order_purchase_timestamp, o.order_id
),
price_calc AS (
    SELECT order_id, SUM(price) AS order_price, MAX(order_item_id) AS product_count
    FROM order_items
    GROUP BY order_id
)
SELECT 
    customer_unique_id,
    MIN(timestamp) AS first_purchase_timestamp,
    MAX(purchase_count) AS number_of_delivered_orders,
    SUM(order_price) AS first_purchase_value,
    SUM(product_count) AS first_purchase_item_count,
    CASE 
        WHEN  MAX(purchase_count) = 1 THEN 'One-time'
        WHEN  MAX(purchase_count) > 1 THEN 'Repeat'
    END AS customer_type
FROM purchase_calc AS pur
INNER JOIN price_calc AS pri
    ON pur.order_id = pri.order_id
WHERE purchase = 1
GROUP BY customer_unique_id, purchase;


----------------------------------------------------------------------

SELECT order_id, COUNT(review_id)
FROM reviews
GROUP BY order_id;

----------------------------------------------------------------------
SELECT
    c.customer_unique_id AS customer_unique_id, 
    o.order_purchase_timestamp AS timestamp,
    o.order_id AS order_id,
    SUM(oi.price) AS order_price
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi
    ON oi.order_id = o.order_id
GROUP BY  c.customer_unique_id, o.order_purchase_timestamp, 
o.order_id;


SELECT order_id, order_item_id, price
FROM order_items;

