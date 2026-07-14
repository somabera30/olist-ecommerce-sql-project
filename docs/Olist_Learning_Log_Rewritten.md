\
# Olist E-commerce SQL Project
# Learning Log

> **Purpose**
>
> This document is a reusable knowledge base built while working on the Olist E-commerce SQL project.
>
> It is designed to:
> - Refresh important SQL and database concepts quickly.
> - Help recreate future SQL projects.
> - Restore project context when continuing with an AI assistant.
> - Capture principles and mindset rather than day-to-day commands.

---

# Table of Contents

1. Git & Project Setup
2. Database Design
3. PostgreSQL & Data Import
4. Data Profiling
5. Business Mindset
6. Project Journey

---

# 1. Git & Project Setup

## Topics Covered
- Project structure
- README.md
- .gitignore
- Basic Git workflow
- Protecting datasets

### Project Structure
Created a clean project structure for SQL scripts, datasets and documentation using:
- PostgreSQL
- pgAdmin 4
- Visual Studio Code
- Git

### Git Fundamentals

**Commands learned**

```bash
git init
git status
git add .
git commit -m "message"
git diff
git restore
```

**Key principles**
- Git tracks file history.
- Every commit should represent meaningful progress.
- Commit messages should describe *what changed*, not *when it changed*.
- Git can detect accidental dataset modifications.

### README.md

Purpose:
- Explain the project
- Describe the dataset
- Document tools
- Show folder structure
- Explain how to reproduce the project

### .gitignore

Used to exclude:
- Temporary files
- Editor settings
- Cache files

This keeps the repository clean.

---

# 2. Database Design

## Topics Covered
- Relational databases
- Business entities
- Primary Keys
- Foreign Keys
- Parent–Child relationships
- Data types
- NULL handling
- ERD

### Relational Thinking

Databases are designed around business entities instead of one large spreadsheet.

Example entities:
- Customers
- Orders
- Products
- Sellers

Benefits:
- Reduce duplication
- Maintain integrity
- Easier maintenance
- Better scalability

### Primary Keys

A Primary Key:
- uniquely identifies each record
- cannot be NULL
- should remain stable

Examples:
- customer_id
- order_id

### Foreign Keys

Foreign Keys connect business entities.

Instead of memorizing syntax, ask:

> Can this record exist without its parent?

If the answer is **No**, a Foreign Key is usually required.

### Parent & Child Tables

General rule:

Parent table → Child table

Example:

Customers

↓

Orders

Tables should be created and imported in dependency order.

### Choosing Data Types

Choose data types based on business meaning.

Examples:
- customer_id → TEXT
- ZIP code → VARCHAR/TEXT
- purchase timestamp → TIMESTAMP
- state → CHAR(2)

Identifiers are often better stored as text because leading zeros matter.

### NULL Values

Instead of asking:

> Should this allow NULL?

Ask:

> Can this event legitimately fail to happen?

Example:
- Purchase timestamp → No
- Delivery timestamp → Yes
- Approval timestamp → Yes

### Entity Relationship Diagram (ERD)

The project ERD includes:
- Customers
- Orders
- Order Items
- Products
- Sellers
- Payments
- Reviews
- Geolocation
- Category Translation

Not every logical relationship is enforced with a Foreign Key.

---

# 3. PostgreSQL & Data Import

## Topics Covered
- COPY
- \copy
- CSV HEADER
- Import order

### Import Order

Never import tables randomly.

General workflow:
1. Profile raw data.
2. Create parent tables.
3. Import parent data.
4. Create child tables.
5. Import child data.

### COPY vs INSERT

Large CSV files should be imported using COPY/\copy instead of INSERT because PostgreSQL is optimized for bulk loading.

### CSV Import

PostgreSQL imports by column position.

CSV HEADER tells PostgreSQL to ignore the first row as data.

Example:

```sql
\copy sellers
FROM '...'
DELIMITER ','
CSV HEADER;
```

---

# 4. Data Profiling

## Topics Covered
- Row counts
- Missing values
- Duplicate validation
- Identifier validation
- Foreign key validation
- Timestamp validation
- Category validation
- Business rule validation

## What is Data Profiling?

Data profiling evaluates data quality before business analysis.

It answers questions like:
- Is data complete?
- Is it valid?
- Does it follow business rules?

### Standard Profiling Checklist

- Row count
- NULL validation
- Duplicate primary keys
- Identifier format
- ZIP code validation
- State validation
- City validation
- Foreign key validation
- Timestamp validation
- Business rule validation

### Important SQL Concepts Learned

- COUNT(*) counts rows.
- COUNT(column) ignores NULL values.
- HAVING filters after GROUP BY.
- LENGTH() is PostgreSQL's string length function.

### Customers Table

Validated:
- Row count
- Missing values
- customer_id uniqueness
- customer_unique_id duplicates
- ZIP code format
- State values
- City values

Learned:
- customer_unique_id is a business identifier.
- Duplicate customer_unique_id values are expected.

### Orders Table

Validated:
- Customer foreign key
- Order status
- Purchase → Approval
- Approval → Carrier
- Carrier → Delivery

Learned:
- Real datasets contain anomalies.
- Data quality issues should be documented rather than hidden.

### Sellers Table

Validated:
- Row count
- Missing values
- seller_id uniqueness
- ZIP code
- State
- City normalization

---

# 5. Business Mindset

## Core Principles

### Think Business Before SQL

Before writing SQL ask:

> What does this data represent?

### Profile Before Analysis

Never jump directly into dashboards.

Understand the data first.

### Validate Before Import

Professional workflow:

Raw Data

↓

Profile

↓

Import

↓

Analysis

### SQL is a Tool

SQL is not the goal.

It is a tool for understanding business data.

### Data Quality

Not every unusual value is incorrect.

Business context determines whether something is an issue.

### Biggest Mindset Shifts

- Databases are designed around business relationships.
- Validation is more valuable than assumptions.
- Documentation is part of analysis.
- A good analyst explains findings instead of only reporting numbers.

---

# 6. Project Journey

## Day 1
- Environment setup
- Git initialized
- Project structure created
- Learned relational database thinking

## Day 2
- Designed ERD
- Learned PK/FK concepts
- Planned database schema

## Day 3
- Created customers and orders tables
- Learned professional import workflow
- Introduced data profiling

## Day 4
- Connected VS Code to PostgreSQL
- Completed customers table profiling

## Day 5
- Completed orders table profiling
- Learned timestamp and foreign key validation

## Day 6
- Imported sellers using \copy
- Completed sellers profiling
- Planned products table
