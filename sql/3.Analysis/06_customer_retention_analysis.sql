-- =========================================================
-- 1. CANONICAL PURCHASE EVENT DEFINITION
-- =========================================================

WITH purchase_calc AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,

        DENSE_RANK() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS purchase

    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id

    WHERE o.order_status = 'delivered'
),
customer_summary AS (
    SELECT
        customer_unique_id,
        MAX(purchase) AS purchase_count,
        CASE
            WHEN MAX(purchase) = 1 THEN 'One-time'
            WHEN MAX(purchase) > 1 THEN 'Repeat'
        END AS customer_type
    FROM purchase_calc
    GROUP BY customer_unique_id
)

-- =========================================================
-- 2. Overall Repeat Purchasing
-- =========================================================
WITH purchase_calc AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,

        DENSE_RANK() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS purchase

    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id

    WHERE o.order_status = 'delivered'
),
customer_summary AS (
    SELECT
        customer_unique_id,
        MAX(purchase) AS purchase_count,
        CASE
            WHEN MAX(purchase) = 1 THEN 'One-time'
            WHEN MAX(purchase) > 1 THEN 'Repeat'
        END AS customer_type
    FROM purchase_calc
    GROUP BY customer_unique_id
)

SELECT
    customer_type,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percentage
FROM customer_summary
GROUP BY customer_type
ORDER BY customer_type;

-- Interpretation:
-- 93,358 delivered customers were identified.
-- 90,793 (97.25%) made one purchase event.
-- 2,565 (2.75%) made more than one purchase event.


-- ============================================================
-- 3. TIME TO SECOND PURCHASE
-- ============================================================

WITH purchase_calc AS (
    SELECT
        c.customer_unique_id AS customer,
        o.order_purchase_timestamp AS purchase_timestamp,

        DENSE_RANK() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS purchase
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        c.customer_unique_id,
        o.order_purchase_timestamp
),
purchase_1 AS (
    SELECT
        customer,
        purchase_timestamp AS ts1
    FROM purchase_calc
    WHERE purchase = 1
),
purchase_2 AS (
    SELECT
        customer,
        purchase_timestamp AS ts2
    FROM purchase_calc
    WHERE purchase = 2
),
durations AS (
    SELECT
        p1.customer,
        FLOOR(
            EXTRACT(EPOCH FROM (p2.ts2 - p1.ts1)) / 86400
        ) AS duration
    FROM purchase_1 AS p1
    INNER JOIN purchase_2 AS p2
        ON p1.customer = p2.customer
)

SELECT
    MODE() WITHIN GROUP (ORDER BY duration) AS mode_of_time_to_second_purchase,
    ROUND(AVG(duration), 2) AS average_time_to_second_purchase,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration) AS median_time_to_second_purchase,
    MIN(duration) AS lowest_time_to_second_purchase,
    MAX(duration) AS highest_time_to_second_purchase
FROM durations;

-- Interpretation:
-- Among the 2,565 repeat customers, 
-- the average time to a second purchase was 88.86 days, 
-- while the median was 41 days. 
-- The difference between the average and median indicates that 
-- some customers took considerably longer to return. 
-- The most common value was 0 days, suggesting that 
-- a meaningful portion of second purchase events occurred 
-- within the same calendar day.


-- ============================================================
-- 3.1. TIME TO SECOND PURCHASE — TIME BUCKETS
-- ============================================================

WITH purchase_calc AS (
    SELECT
        c.customer_unique_id AS customer,
        o.order_purchase_timestamp AS purchase_timestamp,

        DENSE_RANK() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS purchase
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        c.customer_unique_id,
        o.order_purchase_timestamp
),
purchase_1 AS (
    SELECT
        customer,
        purchase_timestamp AS ts1
    FROM purchase_calc
    WHERE purchase = 1
),
purchase_2 AS (
    SELECT
        customer,
        purchase_timestamp AS ts2
    FROM purchase_calc
    WHERE purchase = 2
),
durations AS (
    SELECT
        p1.customer,
        FLOOR(
            EXTRACT(EPOCH FROM (p2.ts2 - p1.ts1)) / 86400
        ) AS duration
    FROM purchase_1 AS p1
    INNER JOIN purchase_2 AS p2
        ON p1.customer = p2.customer
)
SELECT
    COUNT(*) AS total_second_purchase_customers,

    COUNT(*) FILTER (
        WHERE duration = 0
    ) AS within_24_hours,

    COUNT(*) FILTER (
        WHERE duration BETWEEN 1 AND 7
    ) AS within_1_to_7_days,

    COUNT(*) FILTER (
        WHERE duration BETWEEN 8 AND 30
    ) AS within_8_to_30_days,

    COUNT(*) FILTER (
        WHERE duration BETWEEN 31 AND 90
    ) AS within_31_to_90_days,

    COUNT(*) FILTER (
        WHERE duration BETWEEN 91 AND 180
    ) AS within_91_to_180_days,

    COUNT(*) FILTER (
        WHERE duration > 180
    ) AS more_than_180_days,

    ROUND(
        COUNT(*) FILTER (WHERE duration = 0) * 100.0 / COUNT(*),
        1
    ) AS pct_within_24_hours,

    ROUND(
        COUNT(*) FILTER (WHERE duration BETWEEN 1 AND 7) * 100.0 / COUNT(*),
        1
    ) AS pct_within_1_to_7_days,

    ROUND(
        COUNT(*) FILTER (WHERE duration BETWEEN 8 AND 30) * 100.0 / COUNT(*),
        1
    ) AS pct_within_8_to_30_days,

    ROUND(
        COUNT(*) FILTER (WHERE duration BETWEEN 31 AND 90) * 100.0 / COUNT(*),
        1
    ) AS pct_within_31_to_90_days,

    ROUND(
        COUNT(*) FILTER (WHERE duration BETWEEN 91 AND 180) * 100.0 / COUNT(*),
        1
    ) AS pct_within_91_to_180_days,

    ROUND(
        COUNT(*) FILTER (WHERE duration > 180) * 100.0 / COUNT(*),
        1
    ) AS pct_more_than_180_days

FROM durations;

-- OUTPUT:
-- total_2nd_time_purchaser: 2565 customers
-- Within_24_hours: 604 customers (23.5 %)
-- Within_1_to_7_days: 186 customers (7.3 %)
-- within_8_to_30_days: 387 customers (15.1 %)
-- within_31_to_90_days: 494 customers (19.3 %)
-- within_91_to_180_days: 412 customers (16.1 %)
-- Within_more_than_180_days: 482 customers (18.8 %)



-- ============================================================
-- 4. TIME TO THIRD PURCHASE
-- ============================================================

WITH purchase_calc AS (
    SELECT
        c.customer_unique_id AS customer,
        o.order_purchase_timestamp AS purchase_timestamp,

        DENSE_RANK() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS purchase
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        c.customer_unique_id,
        o.order_purchase_timestamp
),

purchase_2 AS (
    SELECT
        customer,
        purchase_timestamp AS ts2
    FROM purchase_calc
    WHERE purchase = 2
),

purchase_3 AS (
    SELECT
        customer,
        purchase_timestamp AS ts3
    FROM purchase_calc
    WHERE purchase = 3
),

durations AS (
    SELECT
        p2.customer,
        FLOOR(
            EXTRACT(EPOCH FROM (p3.ts3 - p2.ts2)) / 86400
        ) AS duration
    FROM purchase_2 AS p2
    INNER JOIN purchase_3 AS p3
        ON p2.customer = p3.customer
)

SELECT
    COUNT(*) AS customers_reaching_third_purchase,
    MODE() WITHIN GROUP (ORDER BY duration) AS mode_of_time_to_third_purchase,
    ROUND(AVG(duration), 2) AS average_time_to_third_purchase,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration)
        AS median_time_to_third_purchase,
    MIN(duration) AS lowest_time_to_third_purchase,
    MAX(duration) AS highest_time_to_third_purchase
FROM durations;

-- Interpretation:
-- Among the 202 customers who reached a third purchase,
-- the average time from the second to the third purchase was 65.62 days,
-- while the median was 41.5 days.
-- The difference between the average and median indicates that
-- some customers took considerably longer to make their third purchase.
-- The most common value was 0 days, suggesting that
-- a meaningful portion of third purchase events occurred
-- within 24 hours of the second purchase.



-- =========================================================
-- 5. First-Purchase Category
-- =========================================================

WITH purchase_calc AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        DENSE_RANK() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS purchase
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp
),
customer_summary AS (
    SELECT
        customer_unique_id,
        MAX(purchase) AS purchase_count,
        CASE
            WHEN MAX(purchase) = 1 THEN 'One-time'
            WHEN MAX(purchase) > 1 THEN 'Repeat'
        END AS customer_type
    FROM purchase_calc
    GROUP BY customer_unique_id
),
category_data AS (
    SELECT
        pc.customer_unique_id,
        CASE
            WHEN COUNT(*) FILTER (
                WHERE p.product_category_name IS NULL
            ) = 0
                THEN 'COMPLETE'

            WHEN COUNT(*) FILTER (
                WHERE p.product_category_name IS NULL
            ) = COUNT(*)
                THEN 'ALL MISSING'

            ELSE 'MIXED'
        END AS product_category_is
    FROM purchase_calc pc
    JOIN order_items oi
        ON pc.order_id = oi.order_id
    LEFT JOIN products p
        ON oi.product_id = p.product_id
    WHERE pc.purchase = 1
    GROUP BY
        pc.customer_unique_id
),
first_purchase_categories AS (
    SELECT DISTINCT
        pc.customer_unique_id,
        p.product_category_name,
        customer_type
    FROM purchase_calc pc
    JOIN order_items oi
        ON pc.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    JOIN category_data cd
        ON pc.customer_unique_id = cd.customer_unique_id
    INNER JOIN customer_summary AS cs
        ON pc.customer_unique_id = cs.customer_unique_id
    WHERE pc.purchase = 1
      AND cd.product_category_is <> 'ALL MISSING'
      AND p.product_category_name IS NOT NULL
),
product_category_name_dist AS (
    SELECT
        product_category_name,
        customer_type,
        COUNT(DISTINCT customer_unique_id) AS customer_count
    FROM first_purchase_categories
    GROUP BY
        product_category_name,
        customer_type
    ORDER BY
        product_category_name,
        customer_type
)
SELECT
    product_category_name,
    SUM(customer_count) AS total_fp_customers,
    COALESCE(
        MAX(customer_count) FILTER (
            WHERE customer_type = 'Repeat'
        ), 0) AS repeat_customers,
    ROUND(
        COALESCE(
            MAX(customer_count) FILTER (
                WHERE customer_type = 'Repeat'
            ), 0)
            * 100.0
        / SUM(customer_count),
    2) AS repeat_percentage
FROM product_category_name_dist
GROUP BY
    product_category_name
HAVING SUM(customer_count) > 1000
ORDER BY
    total_fp_customers DESC, repeat_percentage DESC;

-- Interpretation:
-- Repeat rates varied across first-purchase categories,
-- ranging from 1.58% to 5.16% among categories with more than 1,000 customers.
-- Fashion_bolsas_e_acessorios had the highest repeat rate at 5.16%,
-- followed by moveis_decoracao at 4.15% and cama_mesa_banho at 4.13%.
-- In contrast, eletronicos had the lowest repeat rate at 1.58%.
-- This suggests that the category purchased in a customer's first purchase
-- may be associated with their likelihood of making a repeat purchase.
-- However, category alone does not explain repeat behavior,
-- so these results should be treated as an association rather than a causal relationship.


-- =========================================================
-- 6. First-Purchase Basket Size
-- =========================================================
WITH purchase_calc AS(
    SELECT
        c.customer_unique_id AS customer_unique_id, 
        o.order_purchase_timestamp AS timestamp,
        o.order_id AS order_id,
        DENSE_RANK() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC) AS purchase
    FROM customers AS c
    INNER JOIN orders AS o 
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, o.order_purchase_timestamp, o.order_id
),
customer_summary AS (
    SELECT
        customer_unique_id,
        MAX(purchase) AS purchase_count,
        CASE
            WHEN MAX(purchase) = 1 THEN 'One-time'
            WHEN MAX(purchase) > 1 THEN 'Repeat'
        END AS customer_type
    FROM purchase_calc
    GROUP BY customer_unique_id
),
first_purchase_basket_size_calc AS(
    SELECT 
        pc.customer_unique_id,
        o.order_id,
        COUNT(oi.order_item_id) AS basket_size,
        customer_type
    FROM orders AS o
    INNER JOIN purchase_calc AS pc
        ON o.order_id = pc.order_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    INNER JOIN customer_summary AS cs
        ON pc.customer_unique_id = cs.customer_unique_id
    WHERE purchase = 1
    GROUP BY pc.customer_unique_id, o.order_id,customer_type
),
customer_line_basket_size_calc AS (
    SELECT 
        customer_unique_id,
        SUM(basket_size) AS basket_size,
        customer_type
    FROM first_purchase_basket_size_calc
    GROUP BY customer_unique_id, customer_type
)
SELECT
    basket_size,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE customer_type = 'Repeat') AS repeat_customers,
    ROUND(
        ((COUNT(*) FILTER (WHERE customer_type = 'Repeat')*100.0)/
        COUNT(*)),
    2) AS repeat_rate
FROM customer_line_basket_size_calc
WHERE basket_size <= 6
GROUP BY basket_size
ORDER BY basket_size;

-- Interpretation:
-- Repeat rates were higher among customers whose first purchase
-- contained more items, increasing from 2.00% for one-item purchases
-- to 5.00% for four-item purchases and 8.00% for six-item purchases.
-- However, the number of customers decreases substantially
-- as basket size increases, making the larger basket groups less reliable.
-- Therefore, first-purchase basket size shows some association with repeat purchasing,
-- but the relationship is not consistently increasing and should not be treated
-- as a strong standalone explanation for customer retention.


-- =========================================================
-- 7. Category Combinations
-- =========================================================

WITH purchase_calc AS(
    SELECT
        c.customer_unique_id AS customer_unique_id, 
        o.order_purchase_timestamp AS timestamp,
        o.order_id AS order_id,
        DENSE_RANK() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC) AS purchase
    FROM customers AS c
    INNER JOIN orders AS o 
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, o.order_purchase_timestamp, o.order_id
),
customer_summary AS (
    SELECT
        customer_unique_id,
        MAX(purchase) AS purchase_count,
        CASE
            WHEN MAX(purchase) = 1 THEN 'One-time'
            WHEN MAX(purchase) > 1 THEN 'Repeat'
        END AS customer_type
    FROM purchase_calc
    GROUP BY customer_unique_id
),
first_purchase_category_dim AS (
    SELECT
        pc.customer_unique_id,
        pc.timestamp,
        p.product_category_name,
        cs.customer_type
    FROM orders AS o
    INNER JOIN purchase_calc AS pc
        ON o.order_id = pc.order_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    INNER JOIN products AS p
        ON p.product_id = oi.product_id
    INNER JOIN customer_summary AS cs
        ON pc.customer_unique_id = cs.customer_unique_id
    WHERE pc.purchase = 1
      AND p.product_category_name IS NOT NULL
    GROUP BY
        pc.customer_unique_id,
        pc.timestamp,
        p.product_category_name,
        cs.customer_type
),
category_pairs AS (
    SELECT
        a.customer_unique_id,
        a.timestamp,
        a.product_category_name AS category_1,
        b.product_category_name AS category_2,
        a.customer_type
    FROM first_purchase_category_dim AS a
    INNER JOIN first_purchase_category_dim AS b
        ON a.customer_unique_id = b.customer_unique_id
        AND a.timestamp = b.timestamp
        AND a.product_category_name < b.product_category_name
)
SELECT
    category_1,
    category_2,
    COUNT(DISTINCT customer_unique_id) AS total_customers_count,
    COUNT(DISTINCT customer_unique_id)
        FILTER (WHERE customer_type = 'Repeat') AS repeat_customers,
    ROUND(
        ((COUNT(DISTINCT customer_unique_id) FILTER (WHERE customer_type = 'Repeat')*100.0)/
        COUNT(DISTINCT customer_unique_id)),
    2) AS repeat_rate
FROM category_pairs
GROUP BY
    category_1,
    category_2
HAVING COUNT(DISTINCT customer_unique_id) >= 30
ORDER BY
    total_customers_count DESC,
    repeat_rate DESC;

-- Interpretation:
-- Among first-purchase category combinations with at least 30 customers,
-- cama_mesa_banho + moveis_decoracao had a 10% repeat rate,
-- while cama_mesa_banho + casa_conforto had a 7% repeat rate.
-- Both were higher than the overall repeat customer rate of 2.75%.
-- However, these combinations represent relatively small customer groups,
-- so the results should be treated as directional rather than strong evidence
-- of a relationship between category combinations and repeat purchasing.


-- =========================================================
-- 8. Delivery Experience
-- =========================================================

WITH purchase_calc AS(    
    SELECT        
        c.customer_unique_id AS customer_unique_id,         
        o.order_purchase_timestamp AS timestamp,        
        o.order_id AS order_id,        
        DENSE_RANK() OVER (            
            PARTITION BY c.customer_unique_id            
            ORDER BY o.order_purchase_timestamp ASC
        ) AS purchase       
    FROM customers AS c    
    INNER JOIN orders AS o         
        ON c.customer_id = o.customer_id    
    WHERE o.order_status = 'delivered'    
    GROUP BY 
        c.customer_unique_id, 
        o.order_purchase_timestamp, 
        o.order_id
),
customer_summary AS (
    SELECT
        customer_unique_id,
        MAX(purchase) AS purchase_count,
        CASE
            WHEN MAX(purchase) = 1 THEN 'One-time'
            WHEN MAX(purchase) > 1 THEN 'Repeat'
        END AS customer_type
    FROM purchase_calc
    GROUP BY customer_unique_id
),
first_purchase_delivery_calc AS(    
    SELECT         
        pc.customer_unique_id,        
        o.order_id,        
        o.order_delivered_customer_date,        
        o.order_purchase_timestamp,   

        ROUND(            
            EXTRACT(                
                EPOCH FROM (                    
                    o.order_delivered_customer_date::timestamp - o.order_purchase_timestamp::timestamp                    
        )) / 86400,1) AS days_to_deliver,   

        cs.customer_type    

    FROM orders AS o    
    INNER JOIN purchase_calc AS pc        
        ON o.order_id = pc.order_id  
    INNER JOIN customer_summary AS cs
        ON pc.customer_unique_id = cs.customer_unique_id  
    WHERE purchase = 1        
),
customer_line_delivery_calc AS (    
    SELECT         
        customer_unique_id,        
        MAX(days_to_deliver) AS days_to_deliver,        
        customer_type    
    FROM first_purchase_delivery_calc    
    GROUP BY customer_unique_id, customer_type    
    HAVING COUNT(*) = COUNT(order_delivered_customer_date)
)

SELECT     
    customer_type,    
    MODE() WITHIN GROUP (ORDER BY days_to_deliver) AS mode_days_to_deliver,    
    ROUND(AVG(days_to_deliver),2) AS average_days_to_deliver,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY days_to_deliver) AS P25_days_to_deliver,     
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY days_to_deliver) AS median_days_to_deliver,     
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY days_to_deliver) AS P75_days_to_deliver,     
    MIN(days_to_deliver) AS lowest_days_to_deliver,    
    MAX(days_to_deliver) AS highest_days_to_deliver
FROM customer_line_delivery_calc
GROUP BY customer_type;

-- Interpretation:
-- Delivery times were very similar for one-time and repeat customers,
-- suggesting delivery speed does not meaningfully distinguish repeat purchasing.

-- OUTPUT:
-- "One-time","7.1","12.58",6.8,10.2,15.7,"0.5","209.6"
-- "Repeat","7.9","12.42",6.9,10.4,15.6,"1.0","88.2"



-- =========================================================
-- 9. First-Purchase Order Value
-- =========================================================

WITH purchase_calc AS(
    SELECT
        c.customer_unique_id AS customer_unique_id, 
        o.order_purchase_timestamp AS timestamp,
        o.order_id AS order_id,
        DENSE_RANK() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC) AS purchase 
    FROM customers AS c
    INNER JOIN orders AS o 
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, o.order_purchase_timestamp, o.order_id
),
customer_summary AS (
    SELECT
        customer_unique_id,
        MAX(purchase) AS purchase_count,
        CASE
            WHEN MAX(purchase) = 1 THEN 'One-time'
            WHEN MAX(purchase) > 1 THEN 'Repeat'
        END AS customer_type
    FROM purchase_calc
    GROUP BY customer_unique_id
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
first_purchase_value_dim AS(
    SELECT 
        pur.customer_unique_id,
        MIN(timestamp) AS first_purchase_timestamp,
        MAX(purchase_count) AS number_of_delivered_orders,
        SUM(order_price) AS first_purchase_value,
        SUM(product_count) AS first_purchase_item_count,
        ROUND(AVG(order_review_score),1) AS order_review_score,
        customer_type
    FROM purchase_calc AS pur
    INNER JOIN price_calc AS pri
        ON pur.order_id = pri.order_id
    LEFT JOIN review_score_calc AS rsc
        ON pur.order_id = rsc.order_id
    INNER JOIN customer_summary AS cs
        ON pur.customer_unique_id = cs.customer_unique_id 
    WHERE purchase = 1
    GROUP BY pur.customer_unique_id, customer_type
)
SELECT
    customer_type,
    ROUND(AVG(first_purchase_value)::NUMERIC,2) AS avg_first_purchase_value,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY first_purchase_value) ::NUMERIC,2) AS median_first_purchase_value,     
    ROUND(AVG(first_purchase_item_count)::NUMERIC,1) AS avg_items,
    ROUND(AVG(order_review_score)::NUMERIC,1) AS avg_review_score
FROM first_purchase_value_dim
GROUP BY customer_type;

-- Interpretation:
-- First-purchase value was broadly similar between one-time and repeat customers.
-- The median was $87.00 for one-time customers and $83.36 for repeat customers,
-- suggesting first-purchase spending does not meaningfully distinguish repeat customers.

-- OUTPUT:
-- "One-time","138.14","87.00","1.1","4.2"
-- "Repeat","124.99","83.36","1.2","4.2"


-- =========================================================
-- 10. Customer Location
-- =========================================================

WITH purchase_calc AS (
    SELECT
        c.customer_unique_id,
        o.order_purchase_timestamp,
        o.order_id,        
        DENSE_RANK() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS purchase
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp
),
customer_summary AS (
    SELECT
        customer_unique_id,
        MAX(purchase) AS purchase_count
    FROM purchase_calc
    GROUP BY customer_unique_id
),
location_based_dim AS(
    SELECT 
        cs.customer_unique_id, 
        CASE
            WHEN purchase_count = 1 THEN 'One-time'
            WHEN purchase_count > 1 THEN 'Repeat'
        END AS customer_type,
        c.customer_state
    FROM customer_summary AS cs
    LEFT JOIN customers AS c
        ON cs.customer_unique_id = c.customer_unique_id
),
location_based_fact AS(
    SELECT 
        customer_state,
        COUNT(DISTINCT(customer_unique_id)) AS total_customers,
        COUNT(DISTINCT(customer_unique_id)) FILTER(WHERE customer_type = 'Repeat') AS repeat_customers,
        COUNT(DISTINCT(customer_unique_id)) FILTER(WHERE customer_type = 'One-time') AS one_time
    FROM location_based_dim AS lbd
    GROUP BY customer_state
)
SELECT 
    customer_state,
    total_customers,
    ROUND(
        (repeat_customers*100.0)/total_customers,
    2) AS repeat_rate
FROM location_based_fact
ORDER BY total_customers DESC;

-- Interpretation:
-- Repeat rates were broadly similar across the major customer states,
-- generally remaining around 2–3%.
-- This suggests customer location does not meaningfully distinguish
-- repeat customers from one-time customers.
-- Higher rates in small states are less reliable due to small customer counts.