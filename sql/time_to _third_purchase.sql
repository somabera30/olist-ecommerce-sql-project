WITH purchase_calc AS(
    SELECT
        c.customer_unique_id AS customer, 
        COUNT(*) AS purchase_count 
    FROM customers AS c
    INNER JOIN orders AS o 
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT 
    DISTINCT(purchase_count), COUNT(*) AS customers
FROM purchase_calc
GROUP BY purchase_count
ORDER BY purchase_count;
-- OUTPUT:
/* "purchase_count","customers"
"1","90557"
"2","2573"
"3","181"
"4","28"
"5","9"
"6","5"
"7","3"
"9","1"
"15","1" */

----------------------------------------------------------
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
purchase_2 AS (
    SELECT customer,timestamp AS ts2
    FROM purchase_calc
    WHERE purchase_count > 1
        AND 
            purchase = 2
),
purchase_3 AS (
    SELECT customer,timestamp AS ts3
    FROM purchase_calc
    WHERE purchase_count > 1
        AND 
            purchase = 3
)
SELECT p2.customer, 
    FLOOR(EXTRACT(EPOCH FROM (ts3 - ts2)) / 86400) AS duration
FROM purchase_2 AS p2
INNER JOIN purchase_3 AS p3
    ON p3.customer = p2.customer;
-- OUTPUT: 202 rows returned.

----------------------------------------------------------
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
purchase_2 AS (
    SELECT customer,timestamp AS ts2
    FROM purchase_calc
    WHERE purchase_count > 1
        AND 
            purchase = 2
),
purchase_3 AS (
    SELECT customer,timestamp AS ts3
    FROM purchase_calc
    WHERE purchase_count > 1
        AND 
            purchase = 3
),
durations AS (
    SELECT p2.customer, 
        FLOOR(EXTRACT(EPOCH FROM (ts3 - ts2)) / 86400) AS duration
    FROM purchase_2 AS p2
    INNER JOIN purchase_3 AS p3
        ON p3.customer = p2.customer
)
SELECT 
    MODE() WITHIN GROUP (ORDER BY duration) AS MODE_of_time_to_third_purchase,
    ROUND(AVG(duration),2) AS average_time_to_third_purchase, 
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration) AS median_time_to_third_purchase,
    MIN(duration) AS lowest_time_to_third_purchase,
    MAX(duration) AS highest_time_to_third_purchase
FROM durations;
--OUTPUT: 
-- The most common time to a third distinct purchase was less than 24 hours.
-- Averge time to 3rd purchase is 65.62 days.
-- Median time to 3rd purchase is 41.5 days.
-- Minimum and maximum time to 3rd purchase is 0 day and 346 days respectively.

--------------------------------------------------------------------------------------

/* Analyze purchase timing up to the third purchase only. 
The number of customers reaching a fourth purchase is too small 
to support reliable analysis and could lead to conclusions heavily influenced 
by a small group of customers. */


/* | Metric             | 1st → 2nd Purchase | 2nd → 3rd Purchase |
| ------------------ | -----------------: | -----------------: |
| Customers analyzed |              2,565 |                181 |
| Most common time   | Less than 24 hours | Less than 24 hours |
| Average time       |         88.86 days |         65.62 days |
| Median time        |            41 days |          41.5 days |
| Maximum time       |           608 days |           346 days |

## What this suggests about the repeat purchase journey

### 1. Customers who reach a third purchase return faster on average

The average gap decreases from **88.86 days** for the second purchase to **65.62 days** for the third purchase.

This suggests that customers who continue beyond their second purchase may generally purchase again sooner.

### 2. The typical purchase gap remains similar

The median remains almost unchanged:

* **41 days** → second purchase
* **41.5 days** → third purchase

So we should **not claim that all customers purchase faster after their second purchase**.

The lower average may be influenced by differences in the distribution and the smaller group of customers reaching a third purchase.

### 3. The strongest drop happens before customers reach a third purchase

From your purchase distribution:

* **2,573 customers** made exactly 2 purchases.
* Only **181 customers** made exactly 3 purchases.
* Only **28 customers** made exactly 4 purchases.

The major challenge therefore appears to be:

> **Moving customers from their second purchase to continued purchasing.**

## Repeat Purchase Journey Summary

A small proportion of Olist customers become repeat customers. Among those who do repeat, many stop after their second purchase, while far fewer continue to a third purchase. Customers who reach a third purchase have a shorter average purchase gap, although the median gap remains almost unchanged at around 41 days.

### Important analytical caution

This does **not prove** that making a third purchase causes customers to purchase faster. We are observing different groups of customers:

* Customers who made at least two purchases
* Customers who successfully continued to at least three purchases

So for now, this is a **descriptive pattern**, not a causal conclusion.

## Where we are now

I would consider the **repeat purchase behavior and timing analysis complete**.

The next logical stage is to investigate:

> **What characteristics or experiences are associated with customers who make repeat purchases versus those who make only one purchase?**

That moves us from **what is happening** to **what may be associated with repeat purchasing**. */
