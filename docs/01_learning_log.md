# Day 7 - Learning Log

**Date:** 14 July 2026

## Objective
- Understand the `products` dataset.
- Design the `products` table.
- Import the dataset into PostgreSQL.
- Complete SQL data profiling for the `products` table.

---

## What I Learned

### 1. Understanding the Products Dataset
- Identified the purpose of each column in the products table.
- Learned that the dataset stores metadata (such as name length and description length) instead of the actual product names and descriptions.
- Understood that `product_category_name` acts as a product classification rather than a product identifier.

### 2. Database Design
- Designed the `products` table using appropriate data types.
- Learned that constraints should not be decided solely from sampled data.
- Understood that schema design should be supported by business rules and full dataset profiling.
- Discussed when `INT` is more appropriate than `NUMERIC` for storing measurements.

### 3. PostgreSQL Schema Evolution
- Learned that constraints can be added or removed after profiling using `ALTER TABLE`.
- Understood that profiling helps validate whether additional constraints such as `NOT NULL` are appropriate.

### 4. Products Data Profiling
Performed SQL profiling on the `products` table:
- Verified row count.
- Checked missing values.
- Verified uniqueness of `product_id`.
- Validated `product_id` length.
- Identified products with incomplete catalogue information.
- Identified products with missing physical dimensions.
- Found one product with all attributes missing except `product_id`.
- Explored product category distribution.
- Verified product measurements for invalid values.
- Verified photo counts.
- Explored summary statistics of product attributes.

### 5. Data Interpretation
- Observed that products with missing category information also have missing catalogue attributes, indicating incomplete product registration.
- Identified four products with a recorded weight of zero, suggesting a potential data quality issue.
- Reinforced the importance of separating observations from conclusions while interpreting profiling results.

---

## Key Takeaways
- Profiling should validate assumptions rather than create them.
- Constraints should be supported by business rules or complete data verification.
- Source datasets should remain unchanged, even when column names contain spelling mistakes.
- Effective profiling involves identifying patterns and explaining their business meaning, not just reporting query results.

---

## Progress
- ✅ Products table created.
- ✅ Products dataset imported.
- ✅ Products data profiling completed.
- ⏳ Next: Begin work on the `category_translation` table.

# Learning Log – Day 8
**Date:** 15 July 2026

## What I Learned

### 1. Reference Table vs Transaction Table
- Learned that the `geolocation` table is a reference dataset used to map ZIP codes to geographical coordinates.
- Understood that it is different from transaction tables like `orders` or master tables like `customers`.

### 2. Not Every Table Needs a Primary Key
- Learned that some datasets may not contain a natural primary key.
- Verified that `geolocation` contains exact duplicate rows, making it impossible to define a meaningful primary key.

### 3. Exact Duplicate Rows vs Expected Duplicate Values
- Learned to distinguish between:
  - Exact duplicate rows (same values in every column), which indicate duplicate records.
  - Duplicate ZIP codes, which are expected because multiple locations can share the same ZIP code.

### 4. One-to-Many Join Problem
- Understood that joining `customers` directly with `geolocation` on ZIP code can multiply rows because one ZIP code may correspond to multiple geolocation records.
- Learned why this causes row explosion during joins.

### 5. Preparing Data Before Analysis
- Learned that raw datasets are not always suitable for direct analysis.
- Understood that creating a derived dataset (using `DISTINCT`, aggregation, CTEs, or views) before joining is often necessary to produce meaningful results.

### 6. Coordinate Validation
- Learned that valid Earth coordinates satisfy:
  - Latitude: -90 to 90
  - Longitude: -180 to 180
- Used these business rules to validate coordinate data.

### 7. Cross-Table Validation
- Performed validation between `customers`, `sellers`, and `geolocation` to identify ZIP codes without corresponding geolocation records.

## Progress
- Completed Business Understanding for the `geolocation` table.
- Created and imported the `geolocation` table.
- Completed SQL data profiling and documented interpretations for all profiling checks.

````markdown
# Learning Log – Day 10
**Date:** 24 July 2026

## Objective
Profile the **reviews** table by validating data quality, understanding its structure, and identifying potential data issues before moving to exploratory analysis.

---

## Tasks Completed

### 1. Created the Reviews Table
- Designed the `reviews` table based on the dataset and documentation.
- Chose appropriate PostgreSQL data types and constraints.

---

### 2. Imported the Dataset
- Attempted to import the CSV using the default UTF-8 encoding.
- Encountered a character encoding error.
- Identified that the Kaggle dataset is encoded in **LATIN1 (WIN1252)**.
- Successfully imported the dataset using:

```sql
\copy reviews
FROM '.../olist_order_reviews_dataset.csv'
WITH (
    FORMAT csv,
    HEADER,
    DELIMITER ',',
    ENCODING 'LATIN1'
);
```

---

## Data Profiling Completed

Performed the following profiling checks:

1. Row count validation
2. Missing value analysis
3. Duplicate `review_id` validation
4. Duplicate `order_id` validation
5. `review_id` length validation
6. `order_id` length validation
7. Review score range validation (1–5)
8. Timestamp consistency validation
9. Foreign key validation (Reviews → Orders)
10. Foreign key validation (Orders → Reviews)

---

## Key Findings

- Imported **99,224** review records successfully.
- `review_comment_title` contains **11,568 NULL values**.
- `review_comment_message` contains **40,977 NULL values**.
- Many customers submitted ratings without writing comments.
- `review_id` is **not unique**.
  - Some review IDs appear twice.
  - A few appear three times.
- `order_id` is also **not unique**.
  - Some orders contain multiple review records.
- All `review_id` values are valid 32-character identifiers.
- All `order_id` values are valid 32-character identifiers.
- Every review score lies within the valid range of **1–5**.
- No review answer timestamp occurs before its creation date.
- Every review belongs to an existing order.
- Every order has at least one corresponding review record.

---

## Problems Encountered

### CSV Import Failure

The dataset could not be imported initially because PostgreSQL expected UTF-8 encoding while the CSV file was encoded in WIN1252 (LATIN1).

### Resolution

Imported the dataset successfully by specifying:

- `ENCODING 'LATIN1'`

---

## Concepts Learned

- Character encoding can prevent successful CSV imports.
- PostgreSQL allows encoding to be specified during `\copy`.
- A business identifier (`review_id`) is not always a database primary key.
- Data profiling focuses on validating data quality rather than explaining business behavior.
- Foreign key validation can be performed using `LEFT JOIN`.
- Timestamp validation helps verify chronological consistency.

---

## Progress Summary

Completed profiling for:

- ✅ Customers
- ✅ Sellers
- ✅ Products
- ✅ Product Category Translation
- ✅ Geolocation
- ✅ Payments
- ✅ Reviews

---

## Next Steps

- Profile the `order_items` table.
- Complete profiling for all remaining datasets.
- Begin exploratory data analysis (EDA) and business insights.
```
````
# Learning Log – Day 11

**Date:** 2026-07-26

## Objective

Complete the database design phase of the Olist E-commerce SQL project by:

- Finalizing the last table (`order_items`)
- Reviewing the entire database schema
- Organizing the project structure
- Creating the Entity Relationship Diagram (ERD)
- Preparing the project for Exploratory Data Analysis (EDA)

---

# Tasks Completed

## 1. Understood the `order_items` Dataset

Reviewed every column and documented its purpose.

### Key observations

- One order can contain multiple products.
- `order_item_id` is unique only within an order.
- The same product can be sold by multiple sellers.
- Shipping limit date represents the deadline for the seller to hand the item to the logistics partner.
- Freight value represents the delivery charge associated with an order item.

---

## 2. Designed the `order_items` Table

Created the PostgreSQL table using appropriate data types and constraints.

### Design decisions

- Composite Primary Key:
  - `(order_id, order_item_id)`

- Foreign Keys:
  - `order_id → orders`
  - `product_id → products`
  - `seller_id → sellers`

- All columns were defined as `NOT NULL` after validating the dataset.

---

## 3. Imported the Dataset

Imported the `order_items` CSV successfully into PostgreSQL.

Verified that:

- All expected rows were imported.
- No import errors occurred.

---

## 4. Completed Data Profiling for `order_items`

Performed comprehensive profiling checks, including:

- Row count verification
- Missing value validation
- Duplicate detection
- Composite primary key validation
- Identifier length validation
- Price validation
- Freight value validation
- Shipping date validation
- Foreign key validation with:
  - Orders
  - Products
  - Sellers

Documented interpretations for every profiling check.

---

## 5. Reviewed the Entire Database

Performed a complete review of the database schema.

Verified:

- Primary keys
- Composite primary keys
- Foreign keys
- Relationships between tables
- Referential integrity
- Overall normalization

Confirmed that the database structure is suitable for SQL analysis.

---

## 6. Improved Project Structure

Reorganized SQL files into a cleaner workflow.

Current structure:

```text
sql/
│
├── 01_create_database.sql
├── 02_create_tables.sql
├── 03_import_data.sql
│
├── 04_01_customers_profiling.sql
├── 04_02_orders_profiling.sql
├── 04_03_sellers_profiling.sql
├── 04_04_products_profiling.sql
├── 04_05_product_category_translation_profiling.sql
├── 04_06_geolocation_profiling.sql
├── 04_07_payments_profiling.sql
├── 04_08_reviews_profiling.sql
├── 04_09_order_items_profiling.sql
│
├── 05_exploratory_data_analysis.sql
└── 06_business_insights.sql
```

This organization separates:

- Database setup
- Data profiling
- Exploratory analysis
- Business insights

making the project easier to understand and maintain.

---

## 7. Created the ER Diagram

Generated the complete Entity Relationship Diagram using **dbdiagram.io**.

The ERD includes:

- Customers
- Orders
- Sellers
- Products
- Payments
- Reviews
- Order Items

Reference tables:

- Geolocation
- Product Category Name Translation

Verified that the ERD matches the implemented PostgreSQL schema.

---

## 8. Planned Project Documentation

Created a documentation structure for the project.

Planned documents include:

- Learning Log
- Decision Log
- Project Roadmap
- Database Design

This separates technical implementation from project documentation.

---

# Key Learnings

Today I learned that designing a database involves much more than creating tables.

Important lessons include:

- Choosing appropriate primary keys and composite primary keys.
- Using foreign keys only where the data reliably supports referential integrity.
- Organizing SQL scripts into logical stages.
- Creating an ER diagram that reflects the implemented schema instead of an idealized model.
- Keeping project documentation structured and aligned with the actual implementation.

I also gained a better understanding of how database design supports future exploratory analysis and business reporting.

---

# Challenges Faced

- Determining the correct primary key for `order_items`.
- Understanding why `geolocation` should remain an independent table.
- Deciding not to enforce a foreign key for the product category translation table.
- Organizing profiling scripts into a cleaner project structure.
- Learning to generate and review an ER diagram.

---

# Current Project Status

## Database Phase

- ✅ Database Created
- ✅ Tables Created
- ✅ Data Imported
- ✅ Data Profiling Completed
- ✅ Referential Integrity Validated
- ✅ Database Design Reviewed
- ✅ Entity Relationship Diagram Completed
- ✅ Project Structure Organized

## Next Phase

- ⬜ Exploratory Data Analysis (EDA)
- ⬜ Business Insights
- ⬜ Dashboard / Visualization (Optional)
- ⬜ Final README Enhancement
- ⬜ GitHub Portfolio Publication

---

# Reflection

The database development phase is now complete.

The project has progressed from raw CSV files to a fully structured PostgreSQL database with validated data quality, documented profiling results, and a normalized relational design.

The next stage will focus on using SQL to answer business questions, perform exploratory data analysis, and generate insights that demonstrate analytical thinking rather than database implementation skills.