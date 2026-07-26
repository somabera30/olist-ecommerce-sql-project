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