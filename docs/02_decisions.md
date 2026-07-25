## Decision 6 – Adopt an Evidence-Based Schema Design

**Date:** 14 July 2026

### Context
While designing the `products` table, several columns appeared to contain no missing values during data sampling. The question arose whether `NOT NULL` constraints should be added based on the sampled data.

### Decision
Do not define database constraints solely from sampled observations. Create the initial schema using known business rules and verify additional constraints through complete data profiling.

### Reason
- Sampled data does not guarantee the absence of missing values in the full dataset.
- Data profiling provides evidence before strengthening the schema.
- Prevents incorrect assumptions during database design.

### Impact
Future tables will follow the same workflow:
Business Understanding → Table Design → Import → Data Profiling → Strengthen schema if required.

**Date:** 15 July 2026

## Decisions Made

### Workflow
- Continued following the established workflow:
  - Business Understanding → Table Creation → Data Import → SQL Data Profiling → Interpretation.

### Geolocation Table Design
- Created the `geolocation` table without defining a PRIMARY KEY because the dataset contains exact duplicate records.
- Deferred `NOT NULL` constraints until after profiling, following the evidence-based design approach adopted throughout the project.
- Chose `DOUBLE PRECISION` for latitude and longitude to accurately store geographical coordinates.

### Data Profiling
- Classified exact duplicate rows as a valid profiling check.
- Excluded duplicate ZIP codes from profiling since multiple records per ZIP code are expected in the dataset.
- Added coordinate range validation using valid Earth latitude and longitude limits.
- Included cross-table ZIP code validation against `customers` and `sellers` to assess dataset completeness.

### SQL Analysis
- Learned that joining `customers` or `sellers` directly with the raw `geolocation` table can produce row multiplication because one ZIP code may correspond to multiple geolocation records.
- Decided to use an aggregated CTE (one row per ZIP code) when validating ZIP code coverage instead of joining the raw table.

### Documentation
- Maintained the practice of documenting every profiling query with its purpose and interpretation immediately after verification.
```


# Decision Log – Day 10
**Date:** 24 July 2026

## Decisions Made

### 1. Import reviews dataset using LATIN1 encoding
**Decision:**
Imported the `olist_order_reviews_dataset.csv` using `ENCODING 'LATIN1'`.

**Reason:**
The Kaggle CSV file is encoded in WIN1252/LATIN1 rather than UTF-8. Importing with UTF-8 caused character encoding errors.

---

### 2. Do not assign PRIMARY KEY to `review_id`
**Decision:**
Kept `review_id` as a normal column.

**Reason:**
Data profiling showed that some `review_id` values occur multiple times (2 or 3 records), so it cannot uniquely identify each row.

---

### 3. Do not assign PRIMARY KEY to `order_id`
**Decision:**
Kept `order_id` as a foreign key only.

**Reason:**
Some orders have multiple review records, making `order_id` non-unique.

---

### 4. Keep review comment fields nullable
**Decision:**
Did not apply `NOT NULL` constraints to:
- `review_comment_title`
- `review_comment_message`

**Reason:**
A large number of records legitimately contain NULL values because customers can submit ratings without writing comments.

---

### 5. Validate timestamp consistency during profiling
**Decision:**
Included a profiling check to ensure `review_answer_timestamp` is not earlier than `review_creation_date`.

**Reason:**
Chronological validation helps identify invalid or inconsistent timestamp data.

---

### 6. Include foreign key validation as part of profiling
**Decision:**
Verified both relationships:
- Every review belongs to an existing order.
- Every order has at least one review record.

**Reason:**
This confirms referential integrity before moving to analysis.

---

### 7. Separate profiling from business analysis
**Decision:**
Limited profiling to structural and data quality validation.

**Reason:**
Questions such as *why an order has multiple reviews* or *customer review behavior* belong to exploratory/business analysis, not data profiling.

---

## Lessons Reinforced

- CSV encoding problems are common when importing real-world datasets.
- A business identifier is not necessarily a database primary key.
- Data profiling should validate data quality without drawing business conclusions.
- Referential integrity checks are an important part of profiling relational datasets.
```