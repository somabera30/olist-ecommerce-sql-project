# Olist E-commerce SQL Project
## Design Decisions

This document records important database design decisions made throughout the project and the reasoning behind them.

---

## customer_id

Decision

Store as TEXT.

Reason

Customer IDs are identifiers rather than numeric values.

No arithmetic operations will ever be performed on them.

---

## order_id

Decision

Store as TEXT.

Reason

Order IDs uniquely identify orders and are not numeric measurements.

---

## customer_zip_code_prefix

Decision

Store as VARCHAR(5).

Reason

ZIP codes are identifiers.

Leading zeros should be preserved.

---

## customer_unique_id

Decision

Do not make UNIQUE.

Reason

One real customer may own multiple customer accounts.

Future analysis will distinguish between account-level behaviour and real-world customer behaviour.

---

## order_status

Decision

Store as VARCHAR(20).

Reason

The column stores short predefined status values such as:

- delivered
- shipped
- canceled
- invoiced

A long text field is unnecessary.

---

## order_purchase_timestamp

Decision

TIMESTAMP NOT NULL

Reason

Every order must have a purchase timestamp.

---

## order_approved_at

Decision

TIMESTAMP NULL

Reason

Not every order becomes approved.

Failed or cancelled orders may never receive an approval timestamp.

---

## order_delivered_customer_date

Decision

TIMESTAMP NULL

Reason

Some orders may never reach the customer.

---

## Foreign Key Design

Decision

orders.customer_id references customers.customer_id

Reason

An order cannot exist without an existing customer.

This protects referential integrity and prevents orphan records.

---

## Day 4 (2026-07-10)

### Decisions

- Perform data profiling before starting business analysis.
- Follow a consistent profiling workflow:
  1. Row count
  2. Missing values
  3. Duplicate checks
  4. Data format validation
  5. Business rule validation
- Organize every profiling query with:
  - Check number
  - Purpose
  - SQL query
- Write an interpretation after important profiling results instead of only recording the SQL output.

---

## Day 5 (2026-07-11)

### Decisions

- Separate **data profiling** from **data analysis** throughout the project.
  - Profiling validates data quality and structure.
  - Analysis answers business questions and derives insights.

- Treat timeline inconsistencies as **findings**, not immediate errors.
  - Verify them with SQL.
  - Document them.
  - Do not modify the original dataset.

- Document profiling results using interpretations rather than only recording output values.

- Keep profiling focused on data quality checks. Business metrics (delivery time, yearly trends, monthly orders, etc.) will be performed later during the exploration phase.

- Consider the `orders` table profiling complete after validating:
  - Row count
  - Missing values
  - Primary key uniqueness
  - Foreign key integrity
  - Timestamp consistency
  - Order status categories