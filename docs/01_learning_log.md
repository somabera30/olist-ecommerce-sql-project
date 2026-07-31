# Olist E-commerce SQL Project
# Learning Log

> ## Purpose
>
> This document is a reusable knowledge base created while building the Olist E-commerce SQL project.
>
> Rather than recording daily activities, it captures the concepts, workflows, design principles, and analytical thinking developed throughout the project.
>
> The objective is to:
>
> - build a reusable reference for future SQL projects,
> - preserve important technical and business concepts,
> - document professional development beyond SQL syntax,
> - restore project context after long breaks,
> - continuously improve how analytical problems are approached.

---

# Table of Contents

1. Git & Project Setup
2. Database Design
3. PostgreSQL & Data Import
4. Data Profiling
5. Relational Database Modeling
6. Business Analysis Foundations
7. Documentation & Project Organization
8. Business Mindset
9. Project Evolution

---

# 1. Git & Project Setup

## Purpose

A project should be easy to reproduce, maintain and understand before writing the first SQL query.

Good project organisation reduces friction throughout development.

---

## Project Structure

The repository was organised into separate areas for:

- SQL scripts
- Raw datasets
- Documentation
- Database design

Separating these responsibilities keeps the project maintainable as it grows.

---

## Technology Stack

- PostgreSQL
- pgAdmin 4
- Visual Studio Code
- Git

Each tool serves a distinct purpose:

| Tool | Purpose |
|-------|----------|
| PostgreSQL | Database Management System |
| pgAdmin | Database administration |
| VS Code | SQL and documentation |
| Git | Version control |

---

## Git Fundamentals

### Commands Used

```bash
git init
git status
git add .
git commit -m "message"
git diff
git restore
```

### Key Learnings

- Every meaningful milestone should have its own commit.
- Commit messages should describe **what changed**, not when it changed.
- Git protects project history and makes experimentation safer.
- Documentation and SQL should evolve together.

---

## README

The README acts as the project's front page.

A good README explains:

- project objective
- dataset
- technology stack
- folder structure

Someone should understand the project without opening any SQL files.

---

## .gitignore

Version control should include only files that belong to the project.

Typical exclusions:

- cache files
- temporary files
- IDE settings
- operating-system generated files

Keeping the repository clean improves collaboration and readability.

---

# 2. Database Design

## Purpose

Database design should represent how a business operates.

A well-designed schema improves data integrity, simplifies analysis, and creates meaningful relationships between business entities.

---

## Key Principle

> Design the database around the business—not around the dataset.

---

## Relational Thinking

Instead of treating the dataset as one spreadsheet, think in terms of business entities.

Examples:

- Customers
- Orders
- Products
- Sellers
- Payments
- Reviews
- Order Items

Each table answers a different business question.

This approach:

- reduces redundancy
- improves consistency
- simplifies maintenance
- enables scalable analysis

---

## Understand the Business Before Creating Tables

Before designing a table, answer:

- What does one row represent?
- What does each column represent?
- Is this transactional, core or reference data?
- How does this entity relate to others?

Business meaning should guide schema design.

---

## Choosing Data Types

Data types should reflect business meaning.

General guidelines:

| Data | Recommended Type |
|------|------------------|
|  IDs | TEXT |
| ZIP Codes | VARCHAR / TEXT |
| Dates & Time | TIMESTAMP |
| State Codes | CHAR(2) |
| Measurements | Numeric Types |

Example:

Although ZIP codes contain digits, they are identifiers—not quantities.

---

## Primary Keys

A Primary Key should:

- uniquely identify a record
- remain stable
- never contain NULL values

Some datasets require composite keys.

Example:

```
(order_id, order_item_id)
```

because `order_item_id` restarts from 1 within each order.

---

## Foreign Keys

Identify foreign key by asking:

> Can this record exist without its parent?

If the answer is **No**, a foreign key is usually appropriate.

Examples:

- Orders → Customers
- Order Items → Orders
- Order Items → Products
- Order Items → Sellers

Foreign keys preserve business relationships and prevent orphan records.

---

## Parent–Child Relationships

Create tables according to dependency order.

Sequence:

```
Parent Tables

↓

Child Tables
```

This simplifies imports and avoids foreign key dependency issues.

---

## Types of Tables

Understanding the role of each table helps determine how it should be validated.

### Transaction Tables

Store business events.

Examples:

- Orders
- Payments
- Reviews
- Order Items

---

### Core Tables

Store relatively stable business entities.

Examples:

- Customers
- Sellers
- Products

---

### Reference Tables

Support other datasets.

Examples:

- Geolocation
- Product Category Translation

Reference tables often require different validation and constraint strategies.

---

## NULL Handling

NULL values should be determined by business rules.

> Can this business event legitimately never happen?

Examples:

| Column | NULL? | Reason |
|---------|-------|--------|
| Purchase Timestamp | No | Purchase always occurs |
| Delivery Timestamp | Yes | Order may never be delivered |
| Review Comment | Yes | Customer may only provide a rating |

Business meaning should always take precedence over assumptions.

---

## Evidence-Based Schema Design

Avoid strengthening constraints based only on sample observations.

Workflow:

```
Understand the Business

↓

Design Initial Schema

↓

Import Data

↓

Profile the Entire Dataset

↓

Strengthen Constraints
```

Constraints should be supported by evidence rather than assumptions.

---

## Schema Evolution

A database schema should evolve as understanding improves.

After profiling, it may be appropriate to:

- strengthen constraints
- relax constraints
- refine data types
- improve relationships

Schema design is iterative, not one-time work.

---

# 3. PostgreSQL & Data Import

## Purpose

Importing data is more than loading CSV files.

A reliable import workflow establishes confidence in the database before analysis begins.

---

## Import Workflow

Recommended sequence:

1. Understand the dataset.
2. Design the schema.
3. Create parent tables.
4. Import parent tables.
5. Create child tables.
6. Import child tables.
7. Validate imports.
8. Begin profiling.

Following dependency order reduces errors and improves reproducibility.

---

## COPY vs \copy

Large datasets should be imported using PostgreSQL's bulk-loading tools.

### COPY

- Runs on the PostgreSQL server.
- Reads server-side files.

### \copy

- Runs from the PostgreSQL client.
- Reads local files.
- Better suited for local development.

For this project, **\copy** became the standard workflow.

---

## CSV Import Principles

Before importing a dataset, verify:

- column order
- delimiter
- header row
- character encoding

Small import settings can have a significant impact on data quality.

---

## Character Encoding

One dataset failed to import despite correct SQL syntax.

Root cause:

- Reviews dataset encoded as **LATIN1 (WIN1252)** instead of UTF-8.

Lesson:

Import failures are not always SQL problems.

Sometimes the data source itself must be understood before troubleshooting.

---

## Validate Every Import

Never assume an import succeeded simply because no error was reported.

Always verify:

- row count
- missing records
- matching the expected schema

Profiling should only begin after the imported data has been validated.

---

# 4. Data Profiling

## Purpose

Data profiling evaluates whether a dataset is reliable enough for business analysis.

Its objective is not to answer business questions, but to understand the quality, completeness, and integrity of the data before drawing conclusions.

---

## Standard Profiling Workflow

Every table was profiled using a consistent workflow.

1. Row count validation
2. Missing value analysis
3. Primary key validation
4. Duplicate detection
5. Identifier validation
6. Data format validation
7. Business rule validation
8. Foreign key validation
9. Timestamp validation
10. Summary statistics

Using the same workflow across all tables creates consistency and improves reproducibility.

---

## Row Count Validation

The first validation confirms that the imported data matches the source dataset.

Row counts should always be verified before deeper analysis.

---

## Missing Value Analysis

NULL values should be interpreted using business context.

Examples:

| Observation | Interpretation |
|-------------|----------------|
| Missing review comments | Customer submitted only a rating |
| Missing delivery timestamp | Order may never have been delivered |
| Missing product attributes | Product information may be incomplete |

The objective is to distinguish expected missing information from genuine data quality issues.

---

## Identifier Validation

Business identifiers should be validated for:

- uniqueness
- consistency
- formatting
- expected length

**A business identifier is not automatically suitable as a database primary key.**

Examples encountered during the project:

- `review_id`
- `customer_unique_id`

Business meaning determines whether uniqueness should be enforced.

---

## Duplicate Validation

Not every duplicate represents poor data quality.

Different duplicate types require different interpretations.

### Duplicate Identifiers

May represent legitimate business behaviour.

### Exact Duplicate Rows

Require investigation because every column contains identical information.

Understanding the business process is essential before classifying duplicates as errors.

---

## Foreign Key Validation

Relationships between related tables should always be validated.

Typical checks include:

- every child record references an existing parent
- no orphan records exist
- expected relationships remain intact

Referential integrity should be confirmed.

---

## Timestamp Validation

Business events should follow a logical sequence.

Examples:

- Purchase → Approval
- Approval → Shipment
- Shipment → Delivery
- Review Creation → Review Response

Timeline validation helps detect inconsistent records without assuming they are incorrect.

---

## Business Rule Validation

Many validations rely on business logic rather than SQL syntax.

Examples:

- Latitude between -90 and 90
- Longitude between -180 and 180
- Product dimensions greater than zero
- Positive freight values

---

## Cross-Table Validation

Cross-table checks reveal inconsistencies that cannot be detected within a single table.

Examples:

- Orders without customers
- Reviews without orders
- Customers without matching geolocation
- Sellers without matching geolocation

Cross-table validation increases confidence in the relational database.

---

## Summary Statistics

Simple descriptive statistics help understand numerical data before analysis.

Useful measures include:

- minimum
- maximum
- average
- frequency distribution

Unexpected values should be documented rather than immediately corrected.

---

## Observations Before Explanations

A profiling report should describe **what exists**, not **why it exists**.

Example:

Observation

> Four products have zero recorded weight.

Possible Interpretation

> Product information may be incomplete.

Avoid concluding:

> Sellers entered incorrect weights.

Business explanations belong to exploratory analysis, not profiling.

---

# 5. Relational Database Modeling

## Purpose

A relational database models business relationships rather than isolated tables.

Understanding those relationships is essential for designing schemas, writing joins, and interpreting results correctly.

---

## Key Principle

> SQL joins should follow business relationships—not just matching column names.

---

## Relationship Cardinality

Common relationships in the project include:

| Relationship                        | Cardinality       |
| ----------------------------------- | ----------------- |
| One customer → Many orders          | One-to-Many (1:M) |
| One order → Many order items        | One-to-Many (1:M) |
| One product → Many order items      | One-to-Many (1:M) |
| One order → One payment (sometimes) | One-to-One (1:1)  |

Recognising cardinality helps prevent incorrect joins and duplicated results.

---

## Composite Keys

Some business entities require more than one column for uniqueness.

Example:

```
(order_id, order_item_id)
```

The composite key reflects how order items are numbered within each order.

---

## Reference Datasets

Reference tables provide supporting information rather than recording business events.

Examples:

- Geolocation
- Product Category Translation

These datasets often require different validation and constraint strategies.

---

## One-to-Many Join Problems

Joining tables without considering relationship cardinality can multiply rows unexpectedly.

Example:

**Joining raw geolocation data directly with customer records duplicated rows because multiple geolocation records shared the same ZIP code having multiple values of longitudes and latitudes.**

Understanding relationship cardinality is essential before performing analysis.

---

## Prepare Data Before Joining

Source datasets are not always analysis-ready.

Intermediate datasets may be required using:

- DISTINCT
- Aggregation
- Common Table Expressions (CTEs)

Preparing data before joining improves analytical accuracy.

---

## Choosing the Correct Business Entity

The same metric can produce different answers depending on **what is being counted**.

Examples:

| Business Question | Correct Entity |
|-------------------|----------------|
| Number of Orders | `orders` |
| Number of Customers | `customer_unique_id` |
| Number of Items Sold | `order_items` |
| Active Sellers | `seller_id` |

Always identify the business entity before writing aggregation queries.

---

## Understanding Row Granularity

Every table has a natural level of detail (grain).

Examples:

| Table | One Row Represents |
|--------|--------------------|
| Orders | One order |
| Order Items | One purchased item |
| Customers | One customer account |

Knowing the grain prevents incorrect joins, aggregations, and KPI definitions.

---

## COUNT vs COUNT(DISTINCT)

Choosing the correct aggregation depends on the business question.

Examples:

```sql
COUNT(order_id)
```

Counts orders.

```sql
COUNT(DISTINCT customer_unique_id)
```

Counts unique customers.

The SQL function should be chosen only after defining the business metric.

---

# 6. Business Analysis Foundations

## Purpose

Once the database has been validated, the focus shifts from **building the database** to **understanding the business**.

Business analysis begins by defining meaningful questions before writing SQL.

---

## Key Principle

> Business questions drive SQL—not the other way around.

---

## Business Health Report

Rather than exploring every table randomly, begin with a Business Health Report.

Its purpose is to establish a baseline understanding of the business.

Typical KPI categories include:

- Revenue
- Orders
- Customers
- Sellers
- Items Sold
- Delivery Performance
- Customer Experience

A Business Health Report provides context before detailed exploration begins.

---

## Define KPI Meaning Before Writing SQL

Every KPI should be defined in business terms before it is calculated.

Examples:

| KPI | Business Definition |
|-----|----------------------|
| Revenue | Product sales from delivered orders (excluding freight) |
| Customers | Distinct `customer_unique_id` |
| Active Sellers | Sellers with at least one delivered order |
| Delivery Time | Purchase to customer delivery |

The same dataset can support multiple valid definitions.

Choosing the correct definition is a business decision—not a SQL decision.

---

## Interpret KPIs Together

Individual metrics rarely provide complete insight.

Instead of analysing each KPI independently, consider how they relate.

Example:

- Orders
- Customers
- Average Order Value
- Delivery Time
- Review Score

Viewed together, these metrics provide a broader understanding of marketplace performance.

---

## Metrics Raise Questions

Business metrics often identify opportunities for further investigation rather than immediate conclusions.

Example:

Observation

> Approximately 1.03 delivered orders per customer.

Question

> How frequently do customers return?

Not Yet a Conclusion

> Customer retention is poor.

Metrics should guide investigation rather than prematurely answer business questions.

---

## Let Business Questions Guide Analysis

Exploratory analysis should not become a checklist of unrelated SQL queries.

Instead:

```
Business Health Report

↓

Business Question

↓

Focused Analysis

↓

Business Insight

↓

Recommendation
```

A clear analytical objective produces more meaningful results than randomly exploring available tables.

---

# 7. Business Mindset

## Purpose

Technical skills help answer questions.

Analytical thinking helps ask the right questions.

Throughout this project, the biggest improvements came from changing how problems were approached rather than learning additional SQL syntax.

---

## Key Principle

> SQL is a tool. Thinking is the real skill.

---

## Think Business Before SQL

Every SQL query should begin with a business question.

Instead of asking:

> How can I write this query?

Ask:

- What decision should this analysis support?
- What business process am I measuring?
- What business entity should be counted?
- Which KPI best answers this question?

Business understanding should drive technical implementation.

---

## Define the Question Before Looking at the Data

Looking at the data first often leads to random exploration.

A better workflow is:

```
Business Question

↓

Business Metric

↓

Required Data

↓

SQL Query

↓

Interpretation
```

The objective is not to write more SQL—it is to answer meaningful business questions.

---

## Profiling Before Analysis

Reliable insights depend on reliable data.

Profiling should confirm:

- completeness
- consistency
- relationships
- business-rule validity

before attempting to explain business behaviour.

Skipping validation increases the risk of producing misleading insights.

---

## Separate Observations from Conclusions

One of the most important lessons from this project was recognising the difference between seeing something and explaining it.

Example:

Observation

> Average delivered orders per customer ≈ 1.03

This observation raises an important question:

> Why are repeat purchases relatively low?

It does **not** prove:

> Customer retention is poor.

A metric identifies where to investigate.

It does not automatically explain why.

---

## Let Metrics Generate Questions

Business metrics are starting points—not final answers.

Good analytical thinking follows this sequence:

```
Metric

↓

Observation

↓

Question

↓

Investigation

↓

Insight

↓

Recommendation
```

This prevents jumping from numbers directly to conclusions.

---

## Validate Assumptions

Unexpected results should trigger curiosity rather than correction.

When a value looks unusual:

- verify the calculation
- validate the business definition
- understand the business process
- investigate supporting evidence

Avoid assuming the data is wrong simply because it is surprising.

---

## Think in Systems

Individual tables rarely tell the whole story.

Business understanding develops by connecting:

- customers
- sellers
- products
- orders
- payments
- reviews

Relationships often reveal more than isolated metrics.

---

## Every Technical Decision Should Support Analysis

Database design is not an isolated activity.

Choices involving:

- primary keys
- foreign keys
- data types
- constraints
- documentation

should ultimately make analysis more reliable.

---

## Continuous Improvement

Understanding evolves throughout the project.

Earlier assumptions may change after:

- profiling
- validation
- exploratory analysis
- business interpretation

Good analytical work improves through evidence rather than certainty.

---

# 8. Documentation & Project Organization

## Purpose

Documentation preserves knowledge that would otherwise be forgotten.

It explains not only **what was built**, but **why it was built that way**.

---

## Key Principle

> Future you should not have to rediscover today's thinking.

---

## Documentation System

Project documentation was intentionally separated by purpose.

| Document | Purpose |
|----------|---------|
| README | Project overview and setup |
| Learning Log | Reusable concepts and analytical thinking |
| Decision Log | Project-specific architectural decisions |
| Roadmap | Current status and next milestones |
| Database Design | Schema, relationships and ER Diagram |
| Business_health_report | understanding KPI for deeper analysis |

Each document answers a different question instead of trying to do everything.

---

## Organising SQL Scripts

SQL scripts should follow the lifecycle of the project.

Example structure:

```
01_database

02_tables

03_import

04_profiling

05_business_health_report

06_exploratory_analysis

07_business_insights
```

A predictable structure makes projects easier to navigate, review and reproduce.

---

## Documentation Should Capture Thinking

Good documentation explains:

- what was done
- why it was done
- what was learned
- how it can be reused

The reasoning behind a decision is often more valuable than the implementation itself.

---

# 9. Project Evolution

## Purpose

This section captures how analytical thinking evolved throughout the project.

It is not a project diary or roadmap.

Instead, it documents the major shifts in understanding that changed how the project was approached.

---

## From Learning SQL to Understanding Databases

The project began with learning SQL syntax.

Very quickly, it became clear that SQL alone was not enough.

Understanding business entities, relationships and database design became equally important.

---

## From Tables to Business Processes

Initially, tables appeared as independent datasets.

Gradually, they became representations of real business processes.

Examples include:

- customers placing orders
- sellers fulfilling purchases
- products moving through transactions
- reviews reflecting customer experience

This changed how database design and SQL queries were written.

---

## From Data Import to Data Trust

Importing data successfully was no longer considered sufficient.

Confidence in analysis required confidence in the data itself.

Profiling became an essential stage rather than an optional one.

---

## From Writing Queries to Defining Metrics

A major shift occurred after completing the Business Health Report.

Instead of asking:

> Which SQL query should I write?

The question became:

> Which business metric should I define?

This shifted the focus from implementation to business understanding.

---

## From Exploration to Investigation

Earlier, analysis felt like exploring data to discover something interesting.

Now, analysis begins with a business question.

Data is explored with a purpose rather than curiosity alone.

This results in more focused SQL, clearer insights and stronger business recommendations.

---

## Looking Ahead

The project is no longer about building a database.

It is now about understanding how businesses operate through data.

Every future analysis should strengthen this ability:

- ask better questions
- define better metrics
- produce more meaningful business insights