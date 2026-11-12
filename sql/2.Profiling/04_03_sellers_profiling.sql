-- ==========================================
-- Data Profiling : sellers
-- Dataset : olist_sellers_dataset.csv
-- Purpose : Understand data quality 
-- ==========================================

-- Check 1: Row Count
-- Purpose: Verify all rows were imported successfully.
SELECT COUNT(*)
FROM sellers;
-- Expected: 3095 rows
-- Result: 3095 rows imported successfully.


-- Check 2: Missing Values
-- Purpose: Verify mandatory columns contain no NULL values.
SELECT
    COUNT(*) AS total_rows,
    COUNT(seller_id) AS seller_id,
    COUNT(seller_zip_code_prefix) AS zip_code,
    COUNT(seller_city) AS city,
    COUNT(seller_state) AS state
FROM sellers;
-- Interpretation:
-- All columns contain 3,095 values.
-- No NULL values were found.


-- Check 3: Duplicate seller_id
-- Purpose: Verify duplicate seller_id identifiers.
SELECT
    seller_id,
    COUNT(*) AS occurrences
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;
-- Interpretation:
-- seller_id has no duplicates. It acts as PRIMARY KEY having all unique values.


-- Check 4: invalid seller_id
-- Purpose: Verify length of seller_id is 32.
SELECT COUNT(*) AS invalid_seller_id
FROM sellers
WHERE length(seller_id) <> 32;
-- Interpretation:
-- All seller_id values contain exactly 32 characters.


-- Check 5: Approriate Zip code length
-- Purpose: Verify Zip code is of 5 characters.
SELECT COUNT(*) AS invalid_zip_length
FROM sellers
WHERE LENGTH(seller_zip_code_prefix) <> 5;
-- Interpretation:
-- All seller_zip_code_prefix values contain exactly 5 digits.


-- Check 6: Leading 0 is conserved
-- Purpose: Verify leading 0 is not deleted.
SELECT seller_zip_code_prefix
FROM sellers
ORDER BY seller_zip_code_prefix
LIMIT 20;
-- Interpretation:
-- Leading zero of zip codes is preserved.


-- Check 7: seller state name length
-- Purpose: Verify length of state name is of 2 characters
SELECT COUNT(*) AS invalid_state_length
FROM sellers
WHERE LENGTH(seller_state) <> 2;
-- Interpretation:
-- All seller_state has 2 characters only.

-- Check 8: Unique seller_state
-- Purpose: Verify seller_state are valid.
SELECT DISTINCT(seller_state)
FROM sellers
ORDER BY seller_state;
-- Interpretation:
-- Sellers belong to 23 valid Brazilian states.
-- No invalid state codes were found.


-- Check 9: Unique seller_city
-- Purpose: Explore normalized city names for consistency.
SELECT DISTINCT(lower(seller_city))
FROM sellers;
-- Interpretation:
-- City names were explored after converting them to lowercase.
-- No obvious case inconsistencies were observed.


-- Check 10: Seller Distribution by City
-- Purpose: Verify the top most city
SELECT seller_city, COUNT(*)
FROM sellers
GROUP BY seller_city
ORDER BY COUNT(*) DESC;
-- Interpretation:
-- São Paulo has the highest number of sellers (694).
-- Curitiba and Rio de Janeiro are the next largest seller locations.