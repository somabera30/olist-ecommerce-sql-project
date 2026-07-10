-- ==========================================
-- Data Profiling : customers
-- Dataset : olist_customers_dataset.csv
-- Purpose : Understand data quality before import
-- ==========================================

-- Check 1: Row Count
-- Purpose: Verify all rows were imported successfully.
SELECT COUNT(*)
FROM customers;
-- Expected:
-- 99,441 rows


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

-- Check 3: Duplicate customer_id
-- Purpose: Verify duplicate customer_id identifiers.

SELECT
    customer_id,
    COUNT(*) AS occurrences
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Check 4: Duplicate customer_unique_id
-- Purpose: Verify duplicate customer_id identifiers.

SELECT
    customer_unique_id,
    COUNT(*) AS accounts
FROM customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1
ORDER BY accounts DESC;

-- Check 5: Missing Zip codes
-- Purpose: Verify Zip codes has no NULL values.

SELECT COUNT(*) AS missing_zip_codes
FROM customers
WHERE customer_zip_code_prefix IS NULL;

-- Check 6: Approriate Zip code length
-- Purpose: Verify Zip code is of 5 characters.

SELECT COUNT(*) AS invalid_zip_length
FROM customers
WHERE LENGTH(customer_zip_code_prefix) <> 5;

-- Check 7: Leading 0 is conserved
-- Purpose: Verify leading 0 is not deleted.

SELECT customer_zip_code_prefix
FROM customers
ORDER BY customer_zip_code_prefix
LIMIT 20;