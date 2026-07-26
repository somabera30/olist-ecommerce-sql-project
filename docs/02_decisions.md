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

# Decision Log – Day 11

**Date:** 2026-07-26

---

# Decision 1: Use a Composite Primary Key for `order_items`

### Decision
Defined `(order_id, order_item_id)` as the composite primary key.

### Reason
`order_item_id` is unique only within a particular order and restarts from 1 for each new order.

### Benefit
Ensures every order item is uniquely identified while accurately reflecting the dataset structure.

---

# Decision 2: Keep All Foreign Key Constraints

### Decision
Maintained foreign key relationships from `order_items` to:

- orders
- products
- sellers

### Reason
Data profiling confirmed there are no orphan records.

### Benefit
Maintains referential integrity and improves database reliability.

---

# Decision 3: Keep Profiling Scripts Separate by Table

### Decision
Split one large profiling SQL file into individual profiling scripts.

### Reason
A single profiling file became difficult to navigate and maintain.

### Benefit

- Better readability
- Easier debugging
- Faster navigation
- More professional project organization

---

# Decision 4: Organize SQL Files by Development Phase

### Decision
Structured SQL files into logical stages.

### Final Structure

```
01_create_database.sql
02_create_tables.sql
03_import_data.sql

04_01_customers_profiling.sql
...
04_09_order_items_profiling.sql

05_exploratory_data_analysis.sql

06_business_insights.sql
```

### Benefit

- Clear execution order
- Easier for recruiters to follow
- Better maintainability

---

# Decision 5: Keep Data Import Commands in a Separate File

### Decision
Store all `COPY` commands inside `03_import_data.sql`.

### Reason
Separates schema creation from data loading.

### Benefit

The database can be recreated quickly by executing:

1. Create Database
2. Create Tables
3. Import Data

---

# Decision 6: Document Database Design

### Decision
Create a dedicated `database_design.md` document.

### Reason
The README should provide a project overview, while detailed database design deserves its own documentation.

### Benefit

Keeps project documentation organized and easier to navigate.

---

# Decision 7: Create an ER Diagram

### Decision
Generate the Entity Relationship Diagram using **dbdiagram.io**.

### Reason
Visualizing relationships makes the schema easier to understand than SQL alone.

### Benefit

- Improves documentation
- Helps reviewers understand the database quickly
- Adds professionalism to the GitHub repository

---

# Decision 8: Keep Reference Tables Independent

### Decision
Do not create additional foreign keys for:

- `geolocation`
- `product_category_name_translation`

### Reason

- ZIP code prefixes are not unique in the geolocation dataset.
- Product category translation is a lookup table without a reliable unique key for enforcing a foreign key relationship.

### Benefit

Avoids incorrect relationships while preserving data integrity.

---

# Decision 9: Separate EDA from Data Profiling

### Decision
End the database development phase after profiling and validation.

Exploratory Data Analysis (EDA) and Business Insights will be completed in a separate stage.

### Reason

Profiling answers:

> "Is the data clean and reliable?"

EDA answers:

> "What insights can the data provide?"

These are different objectives.

### Benefit

Creates a clear project workflow:

1. Database Setup
2. Data Profiling
3. Exploratory Data Analysis
4. Business Insights

---

# Decision 10: Conclude the Database Development Phase

### Decision
Treat the database implementation as complete after:

- Database creation
- Table creation
- Data import
- Data profiling
- Validation
- ER diagram
- Project organization

### Reason

The project now has a complete and validated relational database ready for analytical queries.

### Outcome

The next phase will focus entirely on SQL analysis and business insights rather than database implementation.