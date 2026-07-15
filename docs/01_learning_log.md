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