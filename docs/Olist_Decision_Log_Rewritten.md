# Olist E-commerce SQL Project
# Decision Log

> ## Purpose
>
> This document records the important architectural and implementation decisions made during the project.
>
> Each decision explains **why a particular approach was chosen**, the alternatives considered where relevant, and its impact on the overall project.
>
> Unlike the Learning Log, this document focuses only on project-specific decisions that influenced the final database design, workflow, or repository organization.

---

# Table of Contents

1. Database Schema Decisions
2. Data Import Decisions
3. Relationship & Constraint Decisions
4. Project Organization Decisions
5. Documentation Decisions

---

# 1. Database Schema Decisions

## Decision 1 – Store Business Identifiers as TEXT

### Context

Columns such as `customer_id`, `order_id`, `product_id`, and `seller_id` uniquely identify business entities but are never used in arithmetic operations.

### Decision

Store business identifiers using the `TEXT` data type.

### Reasoning

- These columns represent identifiers rather than numeric values.
- Leading zeros or formatting should be preserved.
- Numeric storage provides no analytical benefit.

### Impact

Identifiers remain unchanged and are suitable for joins without implying numerical meaning.

---

## Decision 2 – Store ZIP Code Prefix as VARCHAR(5)

### Context

Brazilian ZIP code prefixes may contain leading zeros.

### Decision

Store `customer_zip_code_prefix` and similar ZIP code columns as `VARCHAR(5)`.

### Reasoning

ZIP codes identify locations rather than quantities.

### Impact

Original formatting is preserved and location identifiers remain accurate.

---

## Decision 3 – Do Not Enforce a UNIQUE Constraint on `customer_unique_id`

### Context

Data profiling showed that one customer may appear in multiple platform accounts.

### Decision

Allow duplicate values in `customer_unique_id`.

### Reasoning

The column identifies the person rather than an individual account.

### Impact

Future analyses can distinguish customer-level behavior from account-level behavior.

---

## Decision 4 – Define Composite Primary Key for `order_items`

### Context

`order_item_id` restarts from 1 for every order and is not globally unique.

### Decision

Use `(order_id, order_item_id)` as the composite primary key.

### Reasoning

Only the combination uniquely identifies an order item.

### Impact

The schema accurately reflects the business process while maintaining row uniqueness.

---

## Decision 5 – Apply NULL Constraints Based on Business Rules

### Context

Some business events may legitimately never occur.

### Decision

Allow NULL only where the business process supports missing values.

Examples include:

- Delivery timestamps
- Approval timestamps
- Review comments

### Reasoning

Business meaning is more reliable than assumptions drawn from sample data.

### Impact

The schema represents real-world business behavior more accurately.

---

# 2. Data Import Decisions

## Decision 6 – Use PostgreSQL `\copy` for Bulk Imports

### Context

Data was initially imported using pgAdmin.

### Decision

Standardize on PostgreSQL's `\copy` command.

### Reasoning

- Faster
- Easier to automate
- Works directly from the terminal
- Better reflects real-world PostgreSQL workflows

### Impact

Data imports became more reproducible and easier to maintain.

---

## Decision 7 – Import Reviews Dataset Using LATIN1 Encoding

### Context

The Reviews CSV could not be imported using the default UTF-8 encoding.

### Decision

Import the dataset using `ENCODING 'LATIN1'`.

### Reasoning

The source CSV was encoded using WIN1252/LATIN1.

### Impact

The dataset imported successfully without modifying the original source file.

---

# 3. Relationship & Constraint Decisions

## Decision 8 – Enforce Customer Foreign Key

### Context

Every order should belong to an existing customer.

### Decision

Create a foreign key:

`orders.customer_id → customers.customer_id`

### Reasoning

Orders cannot exist independently of customers.

### Impact

Maintains referential integrity and prevents orphan records.

---

## Decision 9 – Preserve Foreign Keys in `order_items`

### Context

Profiling confirmed valid relationships with Orders, Products, and Sellers.

### Decision

Maintain foreign key constraints for all three relationships.

### Reasoning

The data consistently supports these relationships.

### Impact

Improves database integrity and query reliability.

---

## Decision 10 – Do Not Define a Primary Key for `geolocation`

### Context

The dataset contains exact duplicate rows and ZIP codes are not unique.

### Decision

Leave the table without a primary key.

### Reasoning

No column or column combination reliably identifies every record.

### Impact

The database reflects the structure of the source dataset without introducing artificial uniqueness.

---

## Decision 11 – Keep Reference Tables Independent

### Context

The `geolocation` and `product_category_name_translation` tables do not provide reliable keys for enforcing additional foreign key relationships.

### Decision

Do not create extra foreign keys involving these reference tables.

### Reasoning

Enforcing unsupported relationships could introduce incorrect constraints.

### Impact

The schema remains accurate while avoiding invalid dependencies.

---

# 4. Project Organization Decisions

## Decision 12 – Organize SQL Scripts by Development Phase

### Context

As the project expanded, a flat collection of SQL files became difficult to navigate.

### Decision

Group SQL scripts according to the project workflow.

### Structure

- Database creation
- Table creation
- Data import
- Data profiling
- Exploratory Data Analysis
- Business insights

### Impact

The repository follows a clear execution order and is easier to maintain.

---

## Decision 13 – Separate Profiling Scripts by Table

### Context

Maintaining one large profiling script reduced readability.

### Decision

Create an individual profiling script for each table.

### Reasoning

Smaller scripts are easier to understand, debug, and extend.

### Impact

Improves project organization and simplifies future maintenance.

---

## Decision 14 – Store Import Commands Separately

### Context

Database creation and data loading serve different purposes.

### Decision

Place all import commands in a dedicated SQL file.

### Impact

The database can be recreated using a predictable sequence:

1. Create database
2. Create tables
3. Import data

---

# 5. Documentation Decisions

## Decision 15 – Maintain Separate Project Documents

### Context

A single document became difficult to navigate as the project grew.

### Decision

Separate documentation into:

- README
- Learning Log
- Decision Log
- Project Roadmap
- Database Design

### Reasoning

Each document serves a distinct purpose.

### Impact

Documentation is easier to update, review, and reuse.

---

## Decision 16 – Create an Entity Relationship Diagram

### Context

SQL alone makes it difficult to visualize relationships between tables.

### Decision

Generate an ER Diagram after finalizing the schema.

### Reasoning

The ERD provides a visual representation of the implemented database.

### Impact

Improves documentation quality and helps reviewers understand the schema more quickly.