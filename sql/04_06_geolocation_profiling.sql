-- ==========================================
-- Data Profiling : geolocation
-- Dataset : olist_geolocation_dataset.csv
-- Purpose : Understand data quality
-- ==========================================

-- Check 1: Row Count
-- Purpose: Verify all rows were imported successfully.
SELECT COUNT(*)
FROM geolocation;
-- Expected: 1000163 rows
-- Result: 1000163 rows imported successfully.


-- Check 2: Missing Values
-- Purpose: Verify mandatory columns contain no NULL values.
SELECT
    COUNT(*) AS total_rows,
    COUNT(geolocation_zip_code_prefix) AS zip_code,
    COUNT(geolocation_lat) AS latitude,
    COUNT(geolocation_lng) AS longitude,
    COUNT(geolocation_city) AS city,
    COUNT(geolocation_state) AS state
FROM geolocation;
-- Interpretation:
-- All columns contain 1000163 values.
-- No NULL values were found.


-- Check 3: Exact Duplicate Rows
-- Purpose: Identify completely identical geolocation records.
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    COUNT(*)
FROM geolocation
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
HAVING COUNT(*) > 1
ORDER BY count(*) DESC
LIMIT 10;
-- Interpretation:
-- The geolocation table contains exact duplicate rows.
-- These duplicates may result from duplicate source records or dataset preparation.
-- They should be considered when joining or aggregating geolocation data.


-- Check 4: Approriate Zip code length
-- Purpose: Verify Zip code is of 5 characters.
SELECT COUNT(*) AS invalid_zip_length
FROM geolocation
WHERE LENGTH(geolocation_zip_code_prefix) <> 5;
-- Interpretation:
-- All geolocation_zip_code_prefix values contain exactly 5 characters.


-- Check 5: state name length
-- Purpose: Verify length of state name is of 2 characters
SELECT COUNT(*) AS invalid_state_length
FROM geolocation
WHERE LENGTH(geolocation_state) <> 2;
-- Interpretation:
-- All state has 2 characters only.


-- Check 6: Coordinate Range
-- Purpose: Verify latitude and longitude fall within valid Earth ranges.
SELECT COUNT(*) AS invalid_coordinates
FROM geolocation
WHERE geolocation_lat < -90 OR geolocation_lat > 90
      OR
      geolocation_lng < -180 OR geolocation_lng > 180;
-- Interpretation:
-- No invalid longitude and latitude


-- Check 7: Customer ZIP Coverage
-- Purpose: Verify every customer ZIP code exists in the geolocation dataset.
WITH geo AS (
    SELECT
        geolocation_zip_code_prefix,
        AVG(geolocation_lat) AS lat,
        AVG(geolocation_lng) AS lng
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix
)

SELECT COUNT(c.customer_id)
FROM customers c
LEFT JOIN geo g
ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
WHERE g.lat IS NULL
      OR
      g.lng IS NULL;
-- Interpretation
-- 278 customer ZIP codes do not have a matching geolocation record.


-- Check 8: Seller ZIP Coverage
-- Purpose: Verify every seller ZIP code exists in the geolocation dataset.
WITH geo AS (
    SELECT
        geolocation_zip_code_prefix,
        AVG(geolocation_lat) AS lat,
        AVG(geolocation_lng) AS lng
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix
)

SELECT COUNT(s.seller_id)
FROM sellers s
LEFT JOIN geo g
ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix
WHERE g.lat IS NULL
      OR
      g.lng IS NULL;
-- Interpretation
-- 7 seller ZIP codes do not have a corresponding geolocation record.