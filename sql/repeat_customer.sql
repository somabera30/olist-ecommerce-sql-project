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
review_score_calc AS(
    SELECT
        order_id,
        ROUND(AVG(review_score),1) AS order_review_score
    FROM reviews
    GROUP BY order_id
),
first_purchase_calc AS(
    SELECT 
        customer_unique_id,
        MIN(timestamp) AS first_purchase_timestamp,
        MAX(purchase_count) AS number_of_delivered_orders,
        SUM(order_price) AS first_purchase_value,
        SUM(product_count) AS first_purchase_item_count,
        ROUND(AVG(order_review_score),1) AS order_review_score,
        CASE 
            WHEN  MAX(purchase_count) = 1 THEN 'One-time'
            WHEN  MAX(purchase_count) > 1 THEN 'Repeat'
        END AS customer_type
    FROM purchase_calc AS pur
    INNER JOIN price_calc AS pri
        ON pur.order_id = pri.order_id
    LEFT JOIN review_score_calc AS rsc
        ON pur.order_id = rsc.order_id
    WHERE purchase = 1
    GROUP BY customer_unique_id, purchase
)
SELECT 
    customer_type,
    COUNT(*) AS customer_count,
    ROUND(AVG(first_purchase_value)::numeric,2) AS AVG_FP_value,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY first_purchase_value)::numeric,2) AS median_FP_value,
    ROUND(AVG(first_purchase_item_count)::numeric,2) AS AVG_FP_item_count,
    ROUND(AVG(order_review_score),1) AS AVG_FP_review_score
FROM first_purchase_calc
GROUP BY customer_type;

---------------------------------------------------------------

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
review_score_calc AS(
    SELECT
        order_id,
        ROUND(AVG(review_score),1) AS order_review_score
    FROM reviews
    GROUP BY order_id
),
first_purchase_calc AS(
    SELECT 
        customer_unique_id,
        MIN(timestamp) AS first_purchase_timestamp,
        MAX(purchase_count) AS number_of_delivered_orders,
        SUM(order_price) AS first_purchase_value,
        SUM(product_count) AS first_purchase_item_count,
        ROUND(AVG(order_review_score),1) AS order_review_score,
        CASE 
            WHEN  MAX(purchase_count) = 1 THEN 'One-time'
            WHEN  MAX(purchase_count) > 1 THEN 'Repeat'
        END AS customer_type
    FROM purchase_calc AS pur
    INNER JOIN price_calc AS pri
        ON pur.order_id = pri.order_id
    LEFT JOIN review_score_calc AS rsc
        ON pur.order_id = rsc.order_id
    WHERE purchase = 1
    GROUP BY customer_unique_id, purchase
),
first_purchase_one_time_info AS (
    SELECT 
        customer_type,
        COUNT(*) AS customer_count,
        ROUND(AVG(first_purchase_value)::numeric,2) AS AVG_FP_value,
        ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY first_purchase_value)::numeric,2) AS median_FP_value,
        ROUND(AVG(first_purchase_item_count)::numeric,2) AS AVG_FP_item_count,
        ROUND(AVG(order_review_score),1) AS AVG_FP_review_score
    FROM first_purchase_calc
    WHERE customer_type = 'One-time'
    GROUP BY customer_type
),
first_purchase_repeat_info AS (
    SELECT 
        customer_type,
        COUNT(*) AS customer_count,
        ROUND(AVG(first_purchase_value)::numeric,2) AS AVG_FP_value,
        ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY first_purchase_value)::numeric,2) AS median_FP_value,
        ROUND(AVG(first_purchase_item_count)::numeric,2) AS AVG_FP_item_count,
        ROUND(AVG(order_review_score),1) AS AVG_FP_review_score
    FROM first_purchase_calc
    WHERE customer_type = 'Repeat'
    GROUP BY customer_type
)
SELECT
    fpc.first_purchase_item_count,
    ROUND(COUNT(fpc.customer_unique_id)*100/ MAX(fpot.customer_count) , 2) AS percentage_of_One_time_customers,
    ROUND(COUNT(fpc.customer_unique_id)*100/ MAX(fpr.customer_count) , 2) AS percentage_of_One_time_customers
FROM first_purchase_calc AS fpc
CROSS JOIN first_purchase_one_time_info AS fpot
CROSS JOIN first_purchase_repeat_info AS fpr
GROUP BY fpc.first_purchase_item_count
ORDER BY fpc.first_purchase_item_count;