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
