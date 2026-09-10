-- when order with same timestamp are eliminated
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
--02e9109b7e0a985108b43e573b6afb23
--2004ba7732339d9be65f2236d8887ae4

-------------------------------------------------
    SELECT
        c.customer_unique_id AS customer, 
        o.order_purchase_timestamp AS timestamp,
        RANK() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC) AS rank,
        DENSE_RANK() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC) AS dense,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC, o.order_id ASC) AS row,
        COUNT(*) OVER (
            PARTITION BY c.customer_unique_id) AS purchase_count 
    FROM customers AS c
    INNER JOIN orders AS o 
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered';
-- 23339103d82a054f9729b0554ce22e8c (have 2nd and 3rd orders with same timestamp)
 
66980c3775537536f77b434d74e520f5 (1st 2nd and 3rd orders with same timstamp in all)
e13e8b789e5a8e6fe1445f924a4ed4f6 (1st 2nd and 3rd orders with same timstamp in all)

02e9109b7e0a985108b43e573b6afb23 (have no orders with same timestamp)
2004ba7732339d9be65f2236d8887ae4 (have no orders with same timestamp)
-------------------------------------------------------

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
-------------------------------------------------------

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

