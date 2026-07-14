\
# Olist E-commerce SQL Project
# Decision Log

> **Purpose**
>
> This document records important design and workflow decisions made during the project.
> It focuses on **why** a decision was made, not simply **what** was done.
> Future projects can reuse these decisions unless business requirements differ.

---

# Table of Contents

1. Database Schema Decisions
2. Data Validation & Profiling Decisions
3. Workflow Decisions
4. Documentation Standards

---

# 1. Database Schema Decisions

## Decision 1 – Store `customer_id` as TEXT

**Context**
Customer IDs uniquely identify customers.

**Decision**
Store as `TEXT`.

**Reasoning**
- It is an identifier, not a numeric value.
- Arithmetic operations will never be performed.
- Preserves the original identifier format.

**Impact**
Use the ID only for identification and joins.

---

## Decision 2 – Store `order_id` as TEXT

**Context**
Order IDs uniquely identify orders.

**Decision**
Store as `TEXT`.

**Reasoning**
- Functions purely as an identifier.
- Numeric storage provides no benefit.

---

## Decision 3 – Store `customer_zip_code_prefix` as VARCHAR(5)

**Context**
ZIP codes contain leading zeros.

**Decision**
Store as `VARCHAR(5)`.

**Reasoning**
- ZIP codes are identifiers.
- Leading zeros must be preserved.

---

## Decision 4 – Do Not Make `customer_unique_id` UNIQUE

**Context**
One real customer may create multiple platform accounts.

**Decision**
Do not apply a UNIQUE constraint.

**Reasoning**
- Represents the customer, not an individual account.
- Duplicate values are expected by business design.

**Impact**
Future analyses can distinguish customer-level and account-level behaviour.

---

## Decision 5 – Store `order_status` as VARCHAR(20)

**Context**
The column stores a limited set of short status values.

**Decision**
Store as `VARCHAR(20)`.

**Reasoning**
A long text field is unnecessary.

---

## Decision 6 – Timestamp NULL Rules

| Column | Decision | Reason |
|--------|----------|--------|
| order_purchase_timestamp | NOT NULL | Every order must have a purchase time. |
| order_approved_at | NULL | Cancelled or failed orders may never be approved. |
| order_delivered_customer_date | NULL | Some orders are never delivered. |

---

## Decision 7 – Enforce Customer Foreign Key

**Decision**

`orders.customer_id → customers.customer_id`

**Reasoning**
An order cannot exist without a valid customer.

**Impact**
Maintains referential integrity and prevents orphan records.

---

# 2. Data Validation & Profiling Decisions

## Decision 8 – Profile Data Before Analysis

**Decision**
Always complete data profiling before answering business questions.

**Reasoning**
Business analysis is only reliable when the underlying data has been validated.

---

## Decision 9 – Adopt a Standard Profiling Workflow

Every table should be profiled in the following order:

1. Row count
2. Missing values
3. Primary key uniqueness
4. Data format validation
5. Foreign key validation (if applicable)
6. Business rule validation

This ensures consistency across all tables.

---

## Decision 10 – Separate Profiling from Analysis

**Decision**
Treat profiling and business analysis as two independent phases.

**Reasoning**
- Profiling evaluates data quality.
- Analysis generates business insights.

Mixing both makes documentation harder to maintain.

---

## Decision 11 – Treat Anomalies as Findings

**Decision**
Do not modify the original dataset when inconsistencies are discovered.

**Reasoning**
- Validate the issue.
- Document it.
- Continue analysis using the original data unless cleaning is explicitly required.

---

## Decision 12 – Define Completion Criteria for Profiling

A table is considered fully profiled after validating:

- Row count
- Missing values
- Primary key uniqueness
- Foreign key integrity (where applicable)
- Business rules
- Important categorical values
- Timestamp consistency (where applicable)

---

# 3. Workflow Decisions

## Decision 13 – Use PostgreSQL `\copy` for Imports

**Context**
CSV files were initially imported through pgAdmin.

**Decision**
Use PostgreSQL's `\copy` command from the terminal.

**Reasoning**
- Faster
- Works directly from VS Code
- Easier to automate
- Closer to real-world PostgreSQL workflows

**Impact**
`\copy` becomes the default import method for this project.

---

# 4. Documentation Standards

## Decision 14 – Organize Profiling Queries Consistently

Each profiling section should contain:

- Check Number
- Purpose
- SQL Query
- Interpretation (where meaningful)

---

## Decision 15 – Document Interpretations, Not Just Outputs

Recording only SQL output provides little long-term value.

Each important validation should explain:
- What was checked.
- What the result means.
- Whether action is required.

This makes the documentation useful for future projects and easier to understand when revisiting the work months later.
