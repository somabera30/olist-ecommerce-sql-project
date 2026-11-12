-- ==========================================
-- Data Profiling : customers
-- Dataset : olist_customers_dataset.csv
-- Purpose : Understand data quality 
-- ==========================================


-- Check 1: Row Count
-- Purpose: Verify all rows were imported successfully.
SELECT COUNT(*)
FROM customers;
-- Expected: 99,441 rows
-- Result: 99,441 rows imported successfully.


-- Check 2: Missing Values
-- Purpose: Verify mandatory columns contain no NULL values.
SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS customer_id,
    COUNT(customer_unique_id) AS customer_unique_id,
    COUNT(customer_zip_code_prefix) AS zip_code,
    COUNT(customer_city) AS city,
    COUNT(customer_state) AS state
FROM customers;
-- Interpretation:
-- All columns contain 99,441 values.
-- No NULL values were found.


-- Check 3: Duplicate customer_id
-- Purpose: Verify duplicate customer_id identifiers.
SELECT
    customer_id,
    COUNT(*) AS occurrences
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
-- Interpretation:
-- customer_id has no duplicates. It acts as PRIMARY KEY having all unique values.


-- Check 4: Duplicate customer_unique_id
-- Purpose: Verify duplicate customer_id identifiers.
SELECT
    customer_unique_id,
    COUNT(*) AS accounts
FROM customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1
ORDER BY accounts DESC;
-- Interpretation:
-- 2,997 customer_unique_id values are associated with more than one customer_id.
-- This is expected because a single customer can place multiple orders.
-- Each order receives a new customer_id, while customer_unique_id identifies the actual customer across orders.


-- Check 5: invalid customer_id
-- Purpose: Verify length of customer_id is 32.
SELECT COUNT(*) AS invalid_customer_id
FROM customers
WHERE length(customer_id) <> 32;
-- Interpretation:
-- All customer_id values contain exactly 32 characters.


-- Check 6: invalid customer_unique_id
-- Purpose: Verify length of customer_unique_id is 32.
SELECT COUNT(*) AS invalid_customer_unique_id
FROM customers
WHERE length(customer_unique_id) <> 32;
-- Interpretation:
-- All customer_unique_id values contain exactly 32 characters.


-- Check 7: Approriate Zip code length
-- Purpose: Verify Zip code is of 5 characters.
SELECT COUNT(*) AS invalid_zip_length
FROM customers
WHERE LENGTH(customer_zip_code_prefix) <> 5;
-- Interpretation:
-- All customer_zip_code_prefix values contain exactly 5 digits.


-- Check 8: Leading 0 is conserved
-- Purpose: Verify leading 0 is not deleted.
SELECT customer_zip_code_prefix
FROM customers
ORDER BY customer_zip_code_prefix
LIMIT 20;
-- Interpretation:
-- Leading zero of zip codes is preserved.


-- Check 9: Customer state name length
-- Purpose: Verify length of state name is of 2 characters
SELECT COUNT(*) AS invalid_state_length
FROM customers
WHERE LENGTH(customer_state) <> 2;
-- Interpretation:
-- All customer_state has 2 characters only.


-- Check 10: Unique customer_state
-- Purpose: Verify customer_state are valid.
SELECT DISTINCT(customer_state)
FROM customers
ORDER BY customer_state;
-- Interpretation:
-- Customers belong to 27 valid Brazilian states.
-- No invalid state codes were found.


-- Check 11: Unique customer_city
-- Purpose: Explore normalized city names for consistency.
SELECT DISTINCT(lower(customer_city))
FROM customers;
-- Interpretation:
-- City names were explored after converting them to lowercase.
-- No obvious case inconsistencies were observed.


-- Check 12: Customer Distribution by City
-- Purpose: Verify the top most city
SELECT customer_city, COUNT(*)
FROM customers
GROUP BY customer_city
ORDER BY COUNT(*) DESC;
-- Interpretation:
-- São Paulo has the highest number of customers (15540).
-- Rio de Janeiro and Belo horizonte are the next largest customer locations.