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