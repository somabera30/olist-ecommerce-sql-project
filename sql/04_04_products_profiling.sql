-- ==========================================
-- Data Profiling : products
-- Dataset : olist_products_dataset.csv
-- Purpose : Understand data quality 
-- ==========================================

-- Check 1: Row Count
-- Purpose: Verify all rows were imported successfully.
SELECT COUNT(*)
FROM products;
-- Expected: 32951 rows
-- Result: 32951 rows imported successfully.

-- Check 2: Missing Values
-- Purpose: Verify mandatory columns contain no NULL values.
SELECT
    COUNT(*) AS total_rows,
    COUNT(product_id) AS product_id,
    COUNT(product_category_name) AS category_name,
    COUNT(product_name_lenght) AS name_lenght,
    COUNT(product_description_lenght) AS description_lenght,
    COUNT(product_photos_qty) AS  photos_qty,
    COUNT(product_weight_g) AS weight_g,
    COUNT(product_length_cm) AS length_cm,
    COUNT(product_height_cm) AS height_cm,
    COUNT(product_width_cm) AS width_cm  
FROM products;
-- Interpretation:
-- product_id has no NULL values qualified as PRIMARY KEY.
-- While product_category_name, product_name_lenght, product_description_lenght and product_photos_qty have 610 NULL values each.
-- Also product_weight_g, product_length_cm,  product_height_cm, product_width_cm have 2 NULL values.


-- Check 3: Duplicate product_id
-- Purpose: Verify duplicate product_id identifiers.
SELECT
    product_id,
    COUNT(*) AS occurrences
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;
-- Interpretation:
-- product_id has no duplicates. It acts as PRIMARY KEY having all unique values.


-- Check 4: -- Check 4: Product ID Length
-- Purpose: Verify length of product_id is 32.
SELECT COUNT(*) AS invalid_product_id
FROM products
WHERE length(product_id) <> 32;
-- Interpretation:
-- All product_id values contain exactly 32 characters.

-- Check 5: Missing Catalogue Attributes
-- Purpose: Verify products with incomplete catalogue information.
SELECT COUNT(product_id)
FROM products
WHERE product_category_name IS NULL
    AND product_name_lenght IS NULL
    AND product_description_lenght IS NULL
    AND product_photos_qty IS NULL;
-- Interpretation:
-- There are 610 product_ids with incomplete catalogue information.


-- Check 6: Missing Product Dimensions
-- Purpose: Verify products with missing physical dimensions.
SELECT COUNT(product_id)
FROM products
WHERE product_weight_g IS NULL
    AND product_length_cm IS NULL
    AND product_height_cm IS NULL
    AND product_width_cm IS NULL;
-- Interpretation:
-- There are 2 product_ids with missing physical dimensions.


-- Check 7: Completely Missing Product Information
-- Purpose: Verify products missing all attributes except product_id.
SELECT product_id
FROM products
WHERE product_category_name IS NULL
    AND product_name_lenght IS NULL
    AND product_description_lenght IS NULL
    AND product_photos_qty IS NULL
    AND product_weight_g IS NULL
    AND product_length_cm IS NULL
    AND product_height_cm IS NULL
    AND product_width_cm IS NULL;
-- Interpretation:
-- Only 1 product_id has every attribute missing except product_id.

-- Check 8: Product Category Distribution
-- Purpose: Explore the distribution of product categories.
SELECT
    product_category_name,
    COUNT(*) AS total_products
FROM products
GROUP BY product_category_name
ORDER BY total_products DESC;
-- Interpretation:
-- The largest product category is cama_mesa_banho with 3,029 products.
-- The next largest categories are esporte_lazer (2,867) and moveis_decoracao (2,857).


-- Check 9: Invalid Product Dimensions
-- Purpose: Verify no product has zero or negative physical dimensions.
SELECT product_id
FROM products
WHERE product_weight_g <= 0
    OR product_length_cm <= 0
    OR product_height_cm <= 0
    OR product_width_cm <= 0;
-- Interpretation:
-- Four product_ids have a recorded weight of zero.
-- No products have negative physical dimensions.


-- Check 10: Invalid Photo Count
-- Purpose: Verify product_photos_qty is not negative.
SELECT product_id
FROM products
WHERE product_photos_qty < 0;
-- Interpretation:
-- No products have a negative photo count.


-- Check 11: Summary Statistics
-- Purpose: Explore the range of product attributes.
SELECT
    MIN(LENGTH(product_category_name)) AS min_category_length,
    MAX(LENGTH(product_category_name)) AS max_category_length,

    MIN(product_name_lenght) AS min_name_length,
    MAX(product_name_lenght) AS max_name_length,

    MIN(product_description_lenght) AS min_description_length,
    MAX(product_description_lenght) AS max_description_length,

    MIN(product_photos_qty) AS min_photos,
    MAX(product_photos_qty) AS max_photos,

    MIN(product_weight_g) AS min_weight_g,
    MAX(product_weight_g) AS max_weight_g,

    MIN(product_length_cm) AS min_length_cm,
    MAX(product_length_cm) AS max_length_cm,

    MIN(product_height_cm) AS min_height_cm,
    MAX(product_height_cm) AS max_height_cm,

    MIN(product_width_cm) AS min_width_cm,
    MAX(product_width_cm) AS max_width_cm
FROM products;
-- Interpretation:
-- Product category names range from 3 to 46 characters.
-- Product name lengths range from 5 to 76 characters.
-- Product description lengths range from 4 to 3,992 characters.
-- Products have between 1 and 20 photos.
-- Product weights range from 0 g to 40,425 g.
-- Product dimensions range from 7–105 cm (length), 2–105 cm (height), and 6–118 cm (width).
-- The minimum weight of 0 g corresponds to the four products identified in Check 9 and should be treated as a data quality issue.