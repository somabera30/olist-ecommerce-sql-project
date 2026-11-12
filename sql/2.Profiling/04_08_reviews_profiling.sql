-- ==========================================
-- Data Profiling : reviews
-- Dataset : olist_oder_reviews_dataset.csv
-- Purpose : Understand data quality
-- ==========================================

-- Check 1: Row Count
-- Purpose: Verify all rows were imported successfully.
SELECT COUNT(*)
FROM reviews;
-- Expected: 99,224 rows
-- Result: 99,224 rows imported successfully.


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