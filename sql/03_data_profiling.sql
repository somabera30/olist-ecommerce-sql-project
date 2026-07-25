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




-- ==========================================
-- Data Profiling : payments
-- Dataset : olist_oder_payments_dataset.csv
-- Purpose : Understand data quality
-- ==========================================

-- Check 1: Row Count
-- Purpose: Verify all rows were imported successfully.
SELECT COUNT(*)
FROM payments;
-- Expected: 103886 rows
-- Result: 103886 rows imported successfully.
-- Interpretation:
-- order_id and payment_sequential together uniquely identify each payment record.


-- Check 2: Missing Values
-- Purpose: Verify mandatory columns contain no NULL values.
SELECT 
    COUNT(*) AS total_rows,
    COUNT(order_id)	AS order_id,
    COUNT(payment_sequential) AS payment_sequential,
    COUNT(payment_type) AS payment_type,	
    COUNT(payment_installments) AS payment_installments,	
    COUNT(payment_value) AS payment_value
FROM payments;
-- Interpretation:
-- All columns contain 103886 values.
-- No NULL values were found.


-- Check 3: invalid order_id
-- Purpose: Verify length of order_id is 32.
SELECT COUNT(*) AS invalid_order_id
FROM payments
WHERE length(order_id) <> 32;
-- Interpretation:
-- All order_id values contain exactly 32 characters.


-- Check 4: Payment Sequence Validation
-- Purpose: Verify every payment sequence starts from 1.
SELECT COUNT(*)
FROM payments
GROUP BY order_id
HAVING MIN(payment_sequential) <> 1;
-- Interpretation:
-- 80 orders have payment sequences that do not start from 1.


-- Check 5: Payment Sequence Validation
-- Purpose: Verify payment sequence numbers are continuous without gaps.
SELECT 
    order_id
FROM payments
GROUP BY order_id
HAVING COUNT(*) <> MAX(payment_sequential)
    AND
        MIN(payment_sequential) = 1;
-- Interpretation:
-- No orders that start with payment sequence 1 have missing sequence numbers in between.


-- Check 6: Distinct payment types
-- Purpose: Identify all payment types present in the dataset.
SELECT
    payment_type,
    COUNT(*)
FROM payments
GROUP BY payment_type;
-- Interpretation:
-- 5 payment types are present: credit_card, boleto, voucher,debit_card and not_defined.
-- credit_card is the most frequently used payment method,
-- followed by boleto, voucher and debit_card.
-- Only 3 payment records have payment_type as 'not_defined'.


-- Check 7: Validating payment_installments
-- Purpose: Identify invalid payment_installments values.
SELECT payment_type, payment_installments, COUNT(order_id)
FROM payments
WHERE payment_installments <= 0
GROUP BY payment_type, payment_installments;
-- Interpretation:
-- Only 2 payment records have payment_installments equal to 0.
-- Both payments were made using credit_card.
-- Since credit card payments generally have at least one installment,
-- these records should be treated as data anomalies.


-- Check 8: Validating payment_values
-- Purpose: Identify payments having zero or negative payment values.
SELECT payment_value, payment_type, COUNT(order_id)
FROM payments
WHERE payment_value <= 0
GROUP BY payment_value, payment_type;
-- 3 payment records have payment_value equal to 0 with payment_type 'not_defined'.
-- 6 payment records have payment_value equal to 0 with payment_type 'voucher'.
-- No payment records have negative payment values.


-- Check 9: Foreign Key Validation
-- Purpose: Verify every order has a corresponding payment record.
SELECT
    o.order_id,
    SUM(p.payment_value)
FROM orders o
LEFT JOIN payments p
ON o.order_id = p.order_id
GROUP BY o.order_id
HAVING SUM(p.payment_value) IS NULL;
-- Interpretation:
-- There is 1 order_id in the orders table that has no corresponding
-- payment record in the payments table.
-- This indicates one order exists without any associated payment information.


-- Check 10: Foreign Key Validation
-- Purpose: Verify every payment record belongs to an existing order.
SELECT COUNT(*)
FROM payments p
LEFT JOIN orders o
ON p.order_id = o.order_id
WHERE o.order_id IS NULL;
-- Interpretation:
-- Every payment record is associated with an existing order.
-- No orphan payment records were found.


-- Check 11: Payment Installment Validation
-- Purpose: Verify boleto and voucher payments are always made in a single installment.
SELECT COUNT(*)
FROM payments
WHERE payment_type IN ('boleto', 'voucher')
  AND payment_installments <> 1;
-- Interpretation:
-- All boleto and voucher payments were made in a single installment.
-- No violations of this business rule were found.




-- ==========================================
-- Data Profiling : reviews
-- Dataset : olist_oder_reviews_dataset.csv
-- Purpose : Understand data quality
-- ==========================================

-- Check 1: Row Count
-- Purpose: Verify all rows were imported successfully.
SELECT COUNT(*)
FROM reviews;
-- Expected: 99224 rows
-- Result: 99224 rows imported successfully.


-- Check 2: Missing Values
-- Purpose: Verify mandatory columns contain no NULL values.
SELECT
    COUNT(*) AS total_rows,
    COUNT(review_id) AS review_id,
    COUNT(order_id) AS order_id,
    COUNT(review_score) AS review_score,
    COUNT(review_comment_title) AS review_comment_title,
    COUNT(review_comment_message) AS review_comment_message,
    COUNT(review_creation_date) AS review_creation_date,
    COUNT(review_answer_timestamp) AS review_answer_timestamp
FROM reviews;
-- Interpretation:
-- review_id, order_id, review_score, review_creation_date and
-- review_answer_timestamp contain no NULL values.
-- review_comment_title has 11,568 NULL values.
-- review_comment_message has 40,977 NULL values.
-- This indicates that many customers submitted ratings without
-- providing a review title and/or detailed written comments.


-- Check 3: Duplicate review_id
-- Purpose: Verify whether review_id uniquely identifies each review.
SELECT DISTINCT(COUNT(*)) AS row_per_review_id
FROM reviews
GROUP BY review_id
HAVING COUNT(review_id) > 1;
-- Interpretation:
-- review_id is not unique.
-- Some review_id values appear 2 times, while a few appear 3 times.
-- Therefore, review_id cannot be used as the PRIMARY KEY of the reviews table.


-- Check 4: Duplicate order_id
-- Purpose: Verify whether an order_id appears more than once in the reviews table.
SELECT DISTINCT(COUNT(*)) AS row_per_order_id
FROM reviews
GROUP BY order_id
HAVING COUNT(order_id) > 1;
-- Interpretation:
-- Some order_id values appear more than once in the reviews table.
-- An order_id can have either 2 or 3 review records.
-- Therefore, order_id alone cannot uniquely identify a review record.


-- Check 5: invalid review_id
-- Purpose: Verify length of review_id is 32.
SELECT COUNT(*) AS invalid_review_id
FROM reviews
WHERE length(review_id) <> 32;
-- Interpretation:
-- All review_id values contain exactly 32 characters.


-- Check 6: invalid order_id
-- Purpose: Verify length of order_id is 32.
SELECT COUNT(*) AS invalid_order_id
FROM reviews
WHERE length(order_id) <> 32;
-- Interpretation:
-- All order_id values contain exactly 32 characters.


-- Check 7: invalid review_score
-- Purpose: Verify review_score is between 1 and 5.
SELECT COUNT(*) AS invalid_order_id
FROM reviews
WHERE review_score < 1
    OR
      review_score > 5;
-- Interpretation:
-- All review_score is between 1 and 5.


-- Check 8: invalid review timestamps
-- Purpose: Verify reviews were answered on or after their creation date.
SELECT COUNT(*) AS invalid_timestamp
FROM reviews
WHERE review_answer_timestamp < review_creation_date;
-- Interpretation:
-- Every review_creation_date occurs before or at the same time as review_answer_timestamp.
-- No invalid review timestamps were found.


-- Check 9: Foreign Key Validation
-- Purpose: Verify every review record belongs to an existing order.
SELECT COUNT(*)
FROM reviews r
LEFT JOIN orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;
-- Interpretation:
-- Every review record is associated with an existing order.
-- No orphan review records were found.


-- Check 10: Foreign Key Validation
-- Purpose: Verify every order has a corresponding review record.
SELECT COUNT(*)
FROM orders o
LEFT JOIN reviews r
ON o.order_id = r.order_id
WHERE r.order_id IS NULL;
-- Interpretation:
-- 768 orders do not have a corresponding review record.
