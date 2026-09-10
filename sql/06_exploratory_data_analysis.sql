-- We have answered:

-- How many customers repeat? → 3%
-- How long until a second distinct purchase? → analyzed for 2,565 customers
-- What does the timing distribution look like? → completed

WITH repeat_customers AS (
    SELECT 
        DISTINCT(c.customer_unique_id)
    FROM customers AS c
    INNER JOIN orders AS o 
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) > 1
),
total_customers AS (
    SELECT
        COUNT(DISTINCT c.customer_unique_id) AS total_customers
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
)
SELECT
    COUNT(*) AS repeat_customers,
    MAX(tc.total_customers) AS total_customers,
    ROUND(
        COUNT(*) * 100.0 / MAX(tc.total_customers),
        2
    ) AS repeat_customer_rate
FROM repeat_customers AS rc, total_customers AS tc;
-- OUTPUT: repeat_customers: 2,801 , total_customers: 93,358 , repeat_customer_rate: 3.00%

-----------------------------------------------------------------

WITH same_timestamp_order_customers AS(
    SELECT
        c.customer_unique_id AS customer, 
        o.order_purchase_timestamp AS timestamp
    FROM customers AS c
    INNER JOIN orders AS o 
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, o.order_purchase_timestamp
    HAVING COUNT(DISTINCT(o.order_id)) > 1
)
SELECT COUNT(DISTINCT(customer)) AS unique_customers_orders_with_same_timestamp
FROM same_timestamp_order_customers;
-- OUTPUT: customers_having_orders_with_same_timestamp: 265


WITH purchase_calc AS(
    SELECT
        c.customer_unique_id AS customer, 
        o.order_purchase_timestamp AS timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC) AS purchase,
        COUNT(*) OVER (
            PARTITION BY c.customer_unique_id) AS purchase_count 
    FROM customers AS c
    INNER JOIN orders AS o 
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, o.order_purchase_timestamp
),
purchase_1 AS (
    SELECT customer,timestamp AS ts1
    FROM purchase_calc
    WHERE purchase_count > 1
        AND 
            purchase = 1
),
purchase_2 AS (
    SELECT customer,timestamp AS ts2
    FROM purchase_calc
    WHERE purchase_count > 1
        AND 
            purchase = 2
)
SELECT p1.customer, 
    ROUND(EXTRACT(EPOCH FROM (ts2 - ts1)) / 86400) AS duration
FROM purchase_1 AS p1
INNER JOIN purchase_2 AS p2
    ON p1.customer = p2.customer;
-- OUTPUT: 2565 rows 
-- also have 0 days as duration denoting the return within 24 hours.

------------------------------------------------------------------

-- Among customers who made a second purchase at a later timestamp, 
-- what is the typical time it took them to make that second purchase?

WITH purchase_calc AS(
    SELECT
        c.customer_unique_id AS customer, 
        o.order_purchase_timestamp AS timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC) AS purchase,
        COUNT(*) OVER (
            PARTITION BY c.customer_unique_id) AS purchase_count 
    FROM customers AS c
    INNER JOIN orders AS o 
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, o.order_purchase_timestamp
),
purchase_1 AS (
    SELECT customer,timestamp AS ts1
    FROM purchase_calc
    WHERE purchase_count > 1
        AND 
            purchase = 1
),
purchase_2 AS (
    SELECT customer,timestamp AS ts2
    FROM purchase_calc
    WHERE purchase_count > 1
        AND 
            purchase = 2
),
durations AS (
    SELECT p1.customer, 
        FLOOR(EXTRACT(EPOCH FROM (ts2 - ts1)) / 86400) AS duration
    FROM purchase_1 AS p1
    INNER JOIN purchase_2 AS p2
        ON p1.customer = p2.customer
)
SELECT 
    MODE() WITHIN GROUP (ORDER BY duration) AS mode_of_time_to_second_purchase,
    ROUND(AVG(duration),2) AS average_time_to_second_purchase, 
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration) AS median_time_to_second_purchase,
    MIN(duration) AS lowest_time_to_second_purchase,
    MAX(duration) AS highest_time_to_second_purchase
FROM durations;
--OUTPUT: 
-- The most common time to a second distinct purchase was less than 24 hours.
-- Averge time to 2nd purchase is 88.86 days.
-- Median time to 2nd purchase is 41 days.
-- Minimum and maximum time to 2nd purchase is 0 day and 608 days respectively.


WITH purchase_calc AS(
    SELECT
        c.customer_unique_id AS customer, 
        o.order_purchase_timestamp AS timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC) AS purchase,
        COUNT(*) OVER (
            PARTITION BY c.customer_unique_id) AS purchase_count 
    FROM customers AS c
    INNER JOIN orders AS o 
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, o.order_purchase_timestamp
),
purchase_1 AS (
    SELECT customer,timestamp AS ts1
    FROM purchase_calc
    WHERE purchase_count > 1
        AND 
            purchase = 1
),
purchase_2 AS (
    SELECT customer,timestamp AS ts2
    FROM purchase_calc
    WHERE purchase_count > 1
        AND 
            purchase = 2
),
durations AS (
    SELECT p1.customer, 
        FLOOR(EXTRACT(EPOCH FROM (ts2 - ts1)) / 86400) AS duration
    FROM purchase_1 AS p1
    INNER JOIN purchase_2 AS p2
        ON p1.customer = p2.customer
)
SELECT 
    COUNT(*) AS total_2nd_time_purchaser,
/*      COUNT(*) FILTER (WHERE duration = 0),
    COUNT(*) FILTER (WHERE duration >=1 AND duration <=7) AS one_to_seven,
    COUNT(*) FILTER (WHERE duration >= 8 AND duration <= 30) AS eight_to,
    COUNT(*) FILTER (WHERE duration >= 31 AND duration <= 90) AS thirtyOne_to,
    COUNT(*) FILTER (WHERE duration >= 91 AND duration <= 180) AS ninetyOne_to,
    COUNT(*) FILTER (WHERE duration > 180) AS oneEighty */
    ROUND((COUNT(*) FILTER (WHERE duration = 0) * 100.0) / count(*), 1) AS Within_24_hours,
    ROUND((COUNT(*) FILTER (WHERE duration >=1 AND duration <=7) * 100.0) / count(*), 1) AS Within_1_to_7_days,
    ROUND((COUNT(*) FILTER (WHERE duration >= 8 AND duration <= 30) * 100.0) / count(*), 1) AS within_8_to_30_days,
    ROUND((COUNT(*) FILTER (WHERE duration >= 31 AND duration <= 90) * 100.0) / count(*), 1) AS within_31_to_90_days,
    ROUND((COUNT(*) FILTER (WHERE duration >= 91 AND duration <= 180) * 100.0) / count(*), 1) AS within_91_to_180_days,
    ROUND((COUNT(*) FILTER (WHERE duration > 180) * 100.0) / count(*), 1) AS Within_more_than_180_days
FROM durations;
-- OUTPUT:
-- total_2nd_time_purchaser: 2565 customers
-- Within_24_hours: 604 customers (23.5 %)
-- Within_1_to_7_days: 186 customers (7.3 %)
-- within_8_to_30_days: 387 customers (15.1 %)
-- within_31_to_90_days: 494 customers (19.3 %)
-- within_91_to_180_days: 412 customers (16.1 %)
-- Within_more_than_180_days: 482 customers (18.8 %)

