-- ==========================================
-- Data Profiling : orders
-- Dataset : olist_orders_dataset.csv
-- Purpose : Understand data quality 
-- ==========================================

-- Check 1: Row Count
-- Purpose: Verify all rows were imported successfully.
SELECT COUNT(*)
FROM orders;
-- Expected: 99,441 rows
-- Result: 99,441 rows imported successfully.

-- Check 2: Missing Values
-- Purpose: Verify columns contain no NULL values.
SELECT
    COUNT(*) AS total_rows,
    COUNT(order_id) AS order_id,
    COUNT(customer_id) AS customer_id,
    COUNT(order_status) AS status,
    COUNT(order_purchase_timestamp) AS purchase,
    COUNT(order_approved_at) AS approved,
    COUNT(order_delivered_carrier_date) AS delivered_carrier_date,
    COUNT(order_delivered_customer_date) AS delivered_customer_date,
    COUNT(order_estimated_delivery_date) AS estimated_delivery_date   
FROM orders;
-- Interpretation:
-- Order_id, customer_id, order_status, order_purchase_timestamp, order_estimated_delivery_date have no NULL values.
-- While order_approved_at, order_delivered_carrier_date, order_delivered_customer_date have some NULL values  .


-- Check 3: Duplicate order_id
-- Purpose: Verify duplicate order_id identifier.
SELECT
    order_id,
    COUNT(*) AS occurrences
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;
-- Interpretation:
-- order_id has no duplicates. It acts as PRIMARY KEY having all unique values.


-- Check 4: Validating FOREIGN KEY
-- Purpose: Verify refrencing of FOREIGN KEY customer_id.
SELECT orders.customer_id
FROM orders
LEFT JOIN customers ON orders.customer_id = customers.customer_id
WHERE customers.customer_id IS NULL;
-- Interpretation:
-- Every customer_id in orders exists in customers.
-- Referential integrity is maintained.
-- No orphan customer records were found.

-- Check 5
-- Purpose: Verify purchase happens before approval.
SELECT COUNT(*) AS invalid_orders
FROM orders
WHERE order_purchase_timestamp > order_approved_at;
-- Interpretation:
-- 0 invalid records found.
-- Every approved order was purchased before approval.


-- Check 6
-- Purpose: Verify approval happens before delivery to carrier.
SELECT COUNT(*) AS invalid_orders
FROM orders
WHERE order_approved_at > order_delivered_carrier_date
    AND 
      order_approved_at IS NOT NULL
    AND 
      order_delivered_carrier_date IS NOT NULL;
-- Result:
-- 1359 orders have carrier timestamp earlier than approval timestamp.
-- This appears to be a data quality issue or system timestamp inconsistency.


-- Check 7
-- Purpose: Verify delivery to carrier happens before delivery to customer.
SELECT COUNT(*) AS invalid_orders
FROM orders
WHERE order_delivered_carrier_date > order_delivered_customer_date
    AND
      order_delivered_carrier_date IS NOT NULL
    AND
      order_delivered_customer_date IS NOT NULL;
-- Result:
-- 23 orders have delivery to customer timestamp earlier than carrier timestamp.
-- This appears to be a data quality issue or system timestamp inconsistency.


-- Check 8:
-- Purpose: Finding the number of anomalies regarded timestamps
SELECT COUNT(*) AS invalid_orders
FROM orders
WHERE order_purchase_timestamp > order_approved_at
    OR
      order_approved_at > order_delivered_carrier_date
    OR
      order_delivered_carrier_date > order_delivered_customer_date;
-- OUTPUT: 1382
-- Result:
-- 1382 orders have some kind of timeline inconsistency.
-- This appears to be a data quality issue or system timestamp inconsistency.


-- Check 9: order_status distribution
-- Purpose: Verify order_status contains only expected categories.
SELECT
  order_status,
  COUNT(*)
FROM orders
GROUP BY order_status
ORDER BY COUNT(*) DESC;
-- Interpretation:
-- order_status contains 8 valid categories:
-- delivered, shipped, canceled, unavailable, invoiced,
-- processing, created and approved.
-- Delivered is the most common order status.
-- 609 orders have the status 'unavailable'.
-- No unexpected or misspelled status values were found.