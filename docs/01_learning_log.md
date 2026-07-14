# Olist E-commerce SQL Project
## Learning Log

This document records the key concepts learned throughout the project. It focuses on understanding rather than documenting every action performed.

---

# Day 1 - Project Setup & Understanding Relational Databases

## Objectives

- Set up the project environment.
- Learn Git fundamentals.
- Understand why relational databases use multiple tables.

---

## Concepts Learned

### Project Setup

Configured the development environment using:

- Visual Studio Code
- PostgreSQL
- pgAdmin 4
- Git

Created the initial project structure for SQL scripts, datasets, and documentation.

---

### Git Fundamentals

Learned how Git tracks project history.

Commands learned:

```bash
git init
git status
git add .
git commit -m "message"
```

Understood that:

- Git tracks changes to files.
- A commit represents a meaningful checkpoint in the project.
- Commits should describe *what changed*, not *when it changed*.

---

### Purpose of README.md

Learned that README.md acts as the project's introduction.

It should explain:

- Project purpose
- Dataset
- Tools used
- Folder structure
- How to reproduce the project

---

### Purpose of .gitignore

Learned why some files should never be tracked by Git.

Examples include:

- temporary files
- editor settings
- cache files

This keeps the repository clean.

---

### Relational Database Thinking

Instead of storing everything in one huge spreadsheet, databases separate information into multiple related tables.

Example:

Customers

Orders

Products

Sellers

Reasons:

- Reduce data duplication
- Maintain data integrity
- Easier updates
- Better scalability
- Easier querying

---

## Key Takeaways

- Git records project history.
- Every commit should represent meaningful progress.
- Databases are designed around business entities rather than spreadsheets.

---

## Insights & Reflections

The first important mindset shift:

Rather than asking

"What command should I run?"

begin asking

"Why is the database designed this way?"

---

## End of Day

✔ Git repository initialized

✔ Project structure created

✔ Development environment ready

---

# Day 2 - Database Design & Relationships

## Objectives

- Understand relational database design.
- Learn Primary Keys.
- Learn Foreign Keys.
- Begin designing the database schema.

---

## Concepts Learned

### Thinking Before Writing SQL

Before selecting a data type or constraint, first ask:

> What does this data represent?

This became the guiding question for database design.

---

### Primary Keys

A Primary Key:

- uniquely identifies every record
- cannot contain NULL values
- should remain stable

Examples:

- customer_id
- order_id

---

### Foreign Keys

A Foreign Key creates relationships between tables.

It ensures that child records always reference an existing parent record.

Example:

orders.customer_id

references

customers.customer_id

This prevents orphan records.

---

### Parent and Child Tables

Learned that parent tables must exist before child tables.

Example:

Customers

↓

Orders

because one customer may place many orders.

---

### Choosing Data Types

Instead of memorizing SQL types, choose them according to business meaning.

Examples:

customer_id → TEXT

order_purchase_timestamp → TIMESTAMP

customer_state → CHAR(2)

order_status → VARCHAR(20)

---

### NULL Values

Instead of asking

"Should this column allow NULL?"

ask

"Can this event fail to happen?"

Examples:

Purchase timestamp

→ Always exists

Delivery timestamp

→ May never happen

Approval timestamp

→ May never happen

---

### Entity Relationship Diagram (ERD)

Created the first ERD connecting:

Customers

Orders

Order Items

Products

Sellers

Payments

Reviews

Geolocation

Category Translation

Learned that some relationships exist logically even if they are not enforced by Foreign Keys.

---

## Key Takeaways

- Database design begins with understanding the business.
- Relationships are more important than individual tables.
- Primary Keys identify.
- Foreign Keys connect.
- Parent tables must be created before child tables.

---

## Insights & Reflections

A major realization:

SQL is only one part of database design.

Understanding business relationships is what determines how the database should be built.

---

## End of Day

✔ ERD completed

✔ Customers table designed

✔ Orders table designed

✔ Foreign Key concept understood

---

# Day 3 - Creating the Schema & Thinking Like a Data Professional

## Objectives

- Create the first relational tables.
- Understand database dependencies.
- Learn how data should be imported into PostgreSQL.
- Begin thinking like a data analyst rather than simply writing SQL.

---

## Concepts Learned

### Building the First Schema

Successfully created:

- customers
- orders

using PostgreSQL.

Understood why the Customers table must be created before Orders.

---

### Business Perspective of Foreign Keys

A Foreign Key exists because an order cannot belong to a customer who does not exist.

Instead of remembering SQL syntax, learned to think:

> Can this record exist without its parent?

If not,

a Foreign Key is required.

---

### Import Order Depends on Relationships

Learned that data should be imported according to table dependencies.

General rule:

Parent tables first

↓

Child tables later

instead of importing files randomly.

---

### Why PostgreSQL Uses COPY

Initially assumed CSV files would be inserted using INSERT.

Learned that PostgreSQL uses COPY because it is optimized for importing large datasets efficiently.

---

### Understanding CSV Import

Learned that PostgreSQL imports data by column position.

It does not automatically understand CSV headers.

HEADER TRUE tells PostgreSQL that the first row contains column names rather than actual data.

---

### Git Protects Data

Opened a CSV in Excel.

Git immediately detected unexpected modifications.

Learned how to use:

git diff

git restore

to inspect and discard unintended changes.

Also learned why Excel is generally avoided for Git-tracked datasets.

---

### ZIP Codes Are Identifiers

Originally considered storing ZIP codes as integers.

Realized they are identifiers rather than numeric values.

Leading zeros should be preserved.

This reinforced the principle:

Identifiers are often better stored as text.

---

### Data Profiling Before Import

Initially planned to import CSV files immediately.

Realized that professional projects first profile raw data.

Questions to answer before importing include:

- Row count
- Missing values
- Duplicate primary keys
- Invalid values
- Business rule violations

Only after understanding the source data should it be loaded into PostgreSQL.

---

## Key Takeaways

- Parent tables are created before child tables.
- Parent data is imported before child data.
- COPY is used for bulk loading.
- Git can protect datasets from accidental modification.
- Data profiling should happen before importing data.

---

## Insights & Reflections

The biggest mindset shift so far:

Instead of asking

"How do I import the CSV?"

began asking

"Shouldn't we validate the data before importing?"

This reflects a transition from learning SQL syntax to understanding professional data workflows.

---

## End of Day

✔ Customers table created

✔ Orders table created

✔ First Foreign Key implemented

✔ Import workflow understood

✔ Professional project workflow redefined

---

# Day 4 (2026-07-10)

## Objective

Begin profiling the `customers` table after importing the data into PostgreSQL.

## What I learned

- Data profiling should be performed before business analysis.
- `COUNT(*)` counts all rows, whereas `COUNT(column)` counts only non-NULL values.
- `customer_id` is unique because it is the Primary Key.
- `customer_unique_id` is a business identifier and can map to multiple `customer_id`s.
- `HAVING` filters grouped results after `GROUP BY`.
- PostgreSQL uses `LENGTH()` to count characters (`LEN()` is used in SQL Server).
- ZIP codes are stored as `VARCHAR(5)` to preserve leading zeros.
- Profiling queries should answer a business validation question, not just return data.

## Work completed

- Connected VS Code to PostgreSQL.
- Profiled row count.
- Checked missing values.
- Validated duplicate `customer_id`.
- Validated duplicate `customer_unique_id`.
- Wrote ZIP code validation queries.

## Next session

- Interpret ZIP code validation results.
- Validate `customer_state`.
- Validate `customer_city`.
- Validate ID formats.
- Complete profiling of the `customers` table.

# Day 5 (11 July 2026) - Orders Data Profiling 

## What I Learned

- Reinforced the difference between **data profiling** and **data analysis**.
  - Data profiling focuses on data quality, structure and validity.
  - Data analysis answers business questions and generates insights.

- Learned to validate timestamp relationships instead of assuming the data is correct.
  - Purchase should occur before approval.
  - Approval should occur before carrier delivery.
  - Carrier delivery should occur before customer delivery.

- Learned that real-world datasets can contain timeline inconsistencies.
  - Not every unexpected result is a SQL mistake.
  - Some anomalies represent genuine data quality issues that should be documented instead of corrected.

- Understood the purpose of validating a foreign key using a `LEFT JOIN`.
  - The goal is to verify that every referenced customer exists in the parent table.

- Learned to write better profiling documentation by explaining the meaning of the results instead of only recording output numbers.

- Confirmed that `order_status` contains only expected categories and documented their distribution as part of data profiling.

## Key Takeaway

A good data analyst does not try to prove the data is perfect. They identify, validate and document data quality issues before performing business analysis.

# Day 6 (12 July 2026)

## Objective
- Understand the `sellers` dataset.
- Learn how to import CSV files into PostgreSQL using VS Code.
- Complete data profiling for the `sellers` table.

---

## What I Learned

### 1. Understanding the Order Items Table
- Learned that one order can contain multiple products.
- Understood the purpose of `order_item_id` as the serial number of an item within an order.
- Identified that `order_items` will eventually require a composite primary key.

### 2. Planning Database Relationships
- Identified `seller_id`, `product_id`, and `order_id` as foreign keys.
- Learned that dependent tables should be created after their parent tables.

### 3. Importing Data from VS Code
- Connected VS Code to PostgreSQL using SQLTools.
- Installed and used the PostgreSQL command-line tool (`psql`).
- Learned to import CSV files using PostgreSQL's `\copy` command instead of pgAdmin.

Example:
```sql
\copy sellers
FROM 'C:/.../olist_sellers_dataset.csv'
DELIMITER ','
CSV HEADER;
```

### 4. Sellers Data Profiling
Performed standard profiling checks on the `sellers` table:
- Verified row count.
- Checked for missing values.
- Verified uniqueness of `seller_id`.
- Validated identifier length.
- Verified ZIP code length.
- Confirmed leading zeros are preserved.
- Validated state code length.
- Reviewed valid seller states.
- Explored normalized city names.
- Identified cities with the highest number of sellers.

### 5. Understanding Business Meaning
- Understood why duplicate `customer_unique_id` values are expected.
- Reinforced the difference between business rules and data quality issues.

---

## Key Takeaways
- PostgreSQL's `\copy` command is a fast and reliable way to import CSV files.
- Data profiling is about understanding the dataset before validation.
- Not every duplicate indicates poor data quality; business context must always be considered.
- SQL is becoming a tool for investigating data rather than simply writing queries.

---

## Progress
- ✅ Sellers table created.
- ✅ Sellers data imported using VS Code.
- ✅ Sellers table profiling completed.
- ⏳ Next: Begin work on the `products` table.