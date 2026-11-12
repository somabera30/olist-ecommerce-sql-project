-- ==========================================
-- Data Profiling : product_category_name_translation
-- Dataset : product_category_name_translation.csv
-- Purpose : Understand data quality
-- ==========================================

-- Check 1: Row Count
-- Purpose: Verify all rows were imported successfully.
SELECT COUNT(*)
FROM product_category_name_translation;
-- Expected: 71 rows
-- Result: 71 rows imported successfully.


-- Check 2: Missing Values
-- Purpose: Verify mandatory columns contain no NULL values.
SELECT
    COUNT(*) AS total_rows,
    COUNT(product_category_name) AS product_category_name,
    COUNT(product_category_name_english) AS product_category_name_english
FROM product_category_name_translation;
-- Interpretation:
-- Both columns contain 71 values.
-- No NULL values were found.


-- Check 3: Duplicate Portuguese Category Names
-- Purpose: Verify product_category_name is unique.
SELECT
    product_category_name,
    COUNT(*) AS occurrences
FROM product_category_name_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;
-- Interpretation:
-- No duplicate Portuguese category names were found.


-- Check 4: Duplicate English Category Names
-- Purpose: Verify translated category names are unique.
SELECT
    product_category_name_english,
    COUNT(*) AS occurrences
FROM product_category_name_translation
GROUP BY product_category_name_english
HAVING COUNT(*) > 1;
-- Interpretation:
-- No duplicate English category names were found.


-- Check 5: Categories Without English Translation
-- Purpose: Identify product categories present in products but missing from the translation table.
SELECT COUNT(*) AS no_english_translation
FROM products
LEFT JOIN product_category_name_translation AS translation
ON products.product_category_name = translation.product_category_name
WHERE products.product_category_name IS NOT NULL
  AND translation.product_category_name_english IS NULL;
-- Interpretation:
-- There are 13 products whose category does not have an English translation.


-- Check 6: Missing Translation Categories
-- Purpose: Identify category names that have no English translation.
SELECT DISTINCT
    products.product_category_name
FROM products
LEFT JOIN product_category_name_translation AS translation
ON products.product_category_name = translation.product_category_name
WHERE products.product_category_name IS NOT NULL
  AND translation.product_category_name_english IS NULL;
-- Interpretation:
-- The categories 'pc_gamer' and
-- 'portateis_cozinha_e_preparadores_de_alimentos'
-- do not have an English translation.