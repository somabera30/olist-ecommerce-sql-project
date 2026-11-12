-- ==========================================
-- Data Profiling : order_items
-- Dataset : olist_order_items_dataset.csv
-- Purpose : Understand data quality
-- ==========================================

-- Check 1: Row Count
-- Purpose: Verify all rows were imported successfully.
SELECT COUNT(*)
FROM order_items;
-- Expected: 112650 rows
-- Result: 112650 rows imported successfully.


-- Check 2: Missing Values
-- Purpose: Verify mandatory columns contain no NULL values.
SELECT
    COUNT(*) AS total_rows,
    COUNT(order_id) AS order_id,
    COUNT(order_item_id) AS order_item_id,
    COUNT(product_id) AS product_id,
    COUNT(seller_id) AS seller_id,
    COUNT(shipping_limit_date) AS shipping_limit_date,
    COUNT(price) AS price,
    COUNT(freight_value) AS freight_value
FROM order_items;
-- Interpretation:
-- All columns contain 103886 values.
-- No NULL values were found.


-- Check 3: Duplicate Composite Primary Key
-- Purpose: Verify (order_id, order_item_id) uniquely identifies each order item.
SELECT
    order_id,
    order_item_id,
    COUNT(*)
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;
-- Interpretation:
-- (order_id, order_item_id) uniquely identifies each order item.


-- Check 4: Invalid order_id
-- Purpose: Verify order_id is 32 characters.
SELECT COUNT(*) AS invalid_order_id
FROM order_items
WHERE LENGTH(order_id) <> 32;
-- Interpretation:
-- All order_id values contain exactly 32 characters.


-- Check 5: Invalid product_id
-- Purpose: Verify product_id is 32 characters.
SELECT COUNT(*) AS invalid_product_id
FROM order_items
WHERE LENGTH(product_id) <> 32;
-- Interpretation:
-- All product_id values contain exactly 32 characters.


-- Check 6: Invalid seller_id
-- Purpose: Verify seller_id is 32 characters.
SELECT COUNT(*) AS invalid_seller_id
FROM order_items
WHERE LENGTH(seller_id) <> 32;
-- Interpretation:
-- All seller_id values contain exactly 32 characters.


-- Check 7: Order Item Sequence Validation
-- Purpose: Verify order_item_id starts from 1 for every order.
SELECT COUNT(*)
FROM order_items
GROUP BY order_id
HAVING MIN(order_item_id) <> 1;
-- Interpretation:
-- All order_item_id start from 1 for every order.


-- Check 8: Missing Item Sequence
-- Purpose: Verify there are no missing order_item_id values within an order.
SELECT
    order_id
FROM order_items
GROUP BY order_id
HAVING COUNT(*) <> MAX(order_item_id)
   AND MIN(order_item_id) = 1;
-- Interpretation:
-- All order_item_id are sequenced properly within an order.
-- No irregularities found.


-- Check 9: Invalid Price
-- Purpose: Verify price is greater than zero.
SELECT COUNT(*)
FROM order_items
WHERE price <= 0;
-- Interpretation:
-- All prices of order-items are valid i.e. non-negative.


-- Check 10: Invalid Freight Value
-- Purpose: Verify freight_value is not negative.
SELECT COUNT(*)
FROM order_items
WHERE freight_value < 0;
-- Interpretation:
-- All Freight values are valid i.e. non-negative


-- Check 11: Foreign Key Validation
-- Purpose: Verify every order item belongs to an existing order.
SELECT COUNT(*)
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;
-- Interpretation:
-- Every order_item record is associated with an existing order.
-- No orphan order_items records were found.


-- Check 12: Foreign Key Validation
-- Purpose: Verify every product exists in the products table.
SELECT COUNT(*)
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;
-- Interpretation:
-- Every product_id is associated with an existing product.
-- No orphan product_id records were found.


-- Check 13: Foreign Key Validation
-- Purpose: Verify every seller exists in the sellers table.
SELECT COUNT(*)
FROM order_items oi
LEFT JOIN sellers s
ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;
-- Interpretation:
-- Every seller_id record is associated with an existing seller.
-- No orphan seller_id records were found.