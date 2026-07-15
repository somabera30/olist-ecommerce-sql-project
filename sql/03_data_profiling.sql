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
-- All seller_state has 2 characters only.


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