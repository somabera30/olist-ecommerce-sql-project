
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
    SELECT order_id, SUM(price) AS order_price, COUNT(*) AS product_count
    FROM order_items
    GROUP BY order_id
),
first_purchase_calc AS(
    SELECT 
        customer_unique_id,
        SUM(product_count) AS first_purchase_item_count,
        CASE 
            WHEN  MAX(purchase_count) = 1 THEN 'One-time'
            WHEN  MAX(purchase_count) > 1 THEN 'Repeat'
        END AS customer_type
    FROM purchase_calc AS pur
    INNER JOIN price_calc AS pri
        ON pur.order_id = pri.order_id
    WHERE purchase = 1
    GROUP BY customer_unique_id, purchase
),
first_purchase_item_count_dist AS (
    SELECT
        customer_type,
        first_purchase_item_count,
        COUNT(*) AS customer_count
    FROM first_purchase_calc
    GROUP BY
        customer_type,
        first_purchase_item_count
    ORDER BY
        customer_type,
        first_purchase_item_count
)
SELECT
    customer_type,
    first_purchase_item_count,
    customer_count,
    ROUND(
        (customer_count * 100.0) / SUM(customer_count) 
        OVER (PARTITION BY customer_type),
        2
    ) AS customer_percentage
FROM first_purchase_item_count_dist
ORDER BY
    customer_type,
    first_purchase_item_count;