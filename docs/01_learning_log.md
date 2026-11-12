# Data Analyst Learning Knowledge Base

> **Purpose:** A compact reference for lessons, analytical principles, and reusable practices learned while building data projects.
>
> This is **not a daily diary** and not a complete record of the Olist project.  
> Project-specific decisions belong in `02_decision_log.md`; project findings belong in the final reports.

---

# Table of Contents

1. [Git & Project Setup](#1-git--project-setup)
2. [Database Design](#2-database-design)
3. [PostgreSQL & Data Import](#3-postgresql--data-import)
4. [Data Profiling](#4-data-profiling)
5. [Relational Database Modeling](#5-relational-database-modeling)
6. [Business Analysis Foundations](#6-business-analysis-foundations)
7. [Business Mindset](#7-business-mindset)
8. [Documentation & Project Organization](#8-documentation--project-organization)
9. [Project Evolution](#9-project-evolution)
10. [Customer Retention Analysis](#10-customer-retention-analysis)
11. [From Analysis to Recommendations](#11-from-analysis-to-recommendations)
12. [Analytical Discipline & Limitations](#12-analytical-discipline--limitations)
13. [Quick Reference](#13-quick-reference)

---

# 1. Git & Project Setup

## Purpose

Use version control to protect work, track meaningful changes, and keep the project reproducible.

## Core Git Concepts

| Command | Purpose |
|---|---|
| `git init` | Initialize a repository |
| `git status` | Check current state |
| `git add` | Stage changes |
| `git commit` | Save a version locally |
| `git push` | Send commits to GitHub |
| `git log` | Review commit history |

### Important distinction

**Commit ≠ push**

- Commit saves a version in the local Git repository.
- Push sends local commits to the remote GitHub repository.

This makes it possible to save work locally without immediately changing the public repository.

## `.gitignore`

Use `.gitignore` to prevent files that should not be version-controlled from entering the repository.

Typical examples:

- raw/large datasets
- credentials
- local configuration
- generated files
- temporary files

## Project Organization

Keep calculations separate from explanation.

```text
sql/     → calculations and analysis
docs/    → findings, decisions and documentation
images/  → diagrams/visuals
README   → project overview
```

A clean structure makes the project easier to review and maintain.

---

# 2. Database Design

## Purpose

A database should represent the business accurately before analysis begins.

## Key Principle

> Design around business entities and relationships, not just around columns in a CSV file.

## Think in Entities

Examples from the Olist project:

- customers
- orders
- order items
- products
- sellers
- payments
- reviews

Each table should have a clear meaning and grain.

## Primary Keys

A primary key identifies a row uniquely.

Before choosing one, verify that the candidate is actually unique.

## Foreign Keys

A foreign key connects a record to another business entity.

Example:

```text
customers
customer_id
    ↓
orders
customer_id
```

Foreign keys help represent relationships and prevent invalid references when enforced.

## Data Types

Choose types based on the meaning and expected values of the data.

Consider:

- text length
- numeric precision
- dates/timestamps
- nullable fields
- identifiers that may contain leading zeros

Do not change source data simply to make it look cleaner without understanding its meaning.

## NULL Handling

`NULL` means missing/unknown, not automatically zero or an empty string.

Always ask:

> What does a missing value mean in this business context?

## Schema Evolution

Initial schema decisions may change after profiling.

That is normal.

A good schema is evidence-driven and can be refined when the data reveals something previously unknown.

---

# 3. PostgreSQL & Data Import

## Purpose

Import the data correctly and verify it before trusting it.

## Import Workflow

```text
Create table
    ↓
Import data
    ↓
Validate row count
    ↓
Check encoding / errors
    ↓
Profile columns
```

## `COPY` vs `\copy`

- `COPY` runs on the PostgreSQL server and requires server-side file access.
- `\copy` runs through the `psql` client and is often easier for local files.

## CSV Import

Check:

- delimiter
- header
- encoding
- quoting
- column order
- data types

An import that completes successfully is not necessarily a correct import.

## Character Encoding

Encoding errors can prevent successful imports or corrupt text.

When text contains accented or non-ASCII characters, verify the source encoding rather than assuming UTF-8.

## Validate Every Import

At minimum:

- compare expected and actual row counts
- inspect representative rows
- check NULLs
- check identifiers
- check dates/timestamps
- check relationships

> **Import success is not data validation.**

---

# 4. Data Profiling

## Purpose

Profiling establishes whether the data is trustworthy enough for analysis.

## Standard Profiling Workflow

```text
Row count
→ Missing values
→ Identifier uniqueness
→ Duplicates
→ Foreign-key relationships
→ Date/timestamp validity
→ Business-rule checks
→ Cross-table validation
→ Summary statistics
```

## Row Counts

Confirm that imported row counts match expectations.

Unexpected differences should be investigated before analysis.

## Missing Values

Do not only count NULLs.

Ask:

> Is this field allowed to be missing?

A missing delivery date for an undelivered order may be expected; the same missing value for a completed delivery may require investigation.

## Identifier Validation

Check whether identifiers are:

- unique when expected
- duplicated when expected
- missing
- correctly related to other tables

## Duplicates

Distinguish between:

- duplicate identifiers
- exact duplicate rows
- legitimate repeated business values

Not every repeated value is a data-quality problem.

## Foreign-Key Validation

Look for child records that do not have a corresponding parent.

This can reveal:

- missing records
- import problems
- incomplete relationships
- legitimate exceptions

## Timestamp Validation

Check for:

- NULL timestamps
- impossible sequences
- negative durations
- unexpected ordering between business events

Unexpected timestamps should be investigated, not automatically deleted.

## Business-Rule Validation

Use business knowledge as a validation tool.

Examples:

- latitude must be between -90 and 90
- longitude must be between -180 and 180
- delivery should not occur before purchase
- quantities/prices should follow reasonable business rules

## Observations Before Explanations

Profiling tells you **what is present**.

It does not automatically tell you **why it happened**.

Keep these separate:

> Observation → possible explanation → evidence needed

---

# 5. Relational Database Modeling

## Purpose

Understand how tables relate before joining them.

## Key Principle

> SQL joins should follow business relationships, not merely matching column names.

## Relationship Cardinality

Common relationships:

| Relationship | Cardinality |
|---|---|
| Customer → Orders | 1:M |
| Order → Order Items | 1:M |
| Product → Order Items | 1:M |

Understanding cardinality prevents row multiplication.

## Composite Keys

Sometimes uniqueness requires more than one column.

Example:

```text
(order_id, order_item_id)
```

The correct key depends on the business grain.

## One-to-Many Join Problem

A join can multiply rows when the parent has multiple matching child records.

Example:

```text
customer
   ↓
many orders
```

If a query joins another one-to-many table without controlling the grain, counts can become inflated.

## Prepare Data Before Joining

Useful techniques:

- `DISTINCT`
- aggregation
- CTEs
- derived tables
- pre-aggregated datasets

Do not assume a join is safe just because the columns match.

## Choose the Correct Business Entity

Always ask what you are counting.

| Question | Entity |
|---|---|
| Number of orders | `order_id` |
| Number of customers | `customer_unique_id` |
| Number of items | order-item rows |
| Number of sellers | `seller_id` |

## Understand Row Grain

Before aggregating, complete this sentence:

> **One row represents ______.**

If you cannot answer it, the query is not ready.

## `COUNT` vs `COUNT(DISTINCT)`

```sql
COUNT(order_id)
```

and

```sql
COUNT(DISTINCT customer_unique_id)
```

answer different business questions.

The aggregation should follow the metric definition, not the other way around.

---

# 6. Business Analysis Foundations

## Purpose

Move from database understanding to business understanding.

## Key Principle

> Business questions drive SQL—not the other way around.

## Start With a Business Health Baseline

Before deep investigation, establish a small set of KPIs such as:

- revenue
- orders
- customers
- sellers
- items
- delivery performance
- customer experience

The baseline gives context for later analysis.

## Define KPIs Before Writing SQL

For every KPI, define:

1. **Business entity**
2. **Scope**
3. **Time period**
4. **Calculation**
5. **Unit**
6. **Exclusions**

Example:

> “Customer” can mean customer account, unique person, buyer, or another business entity.

The same dataset can produce different results depending on the definition.

## Interpret KPIs Together

A single KPI rarely explains business health.

Look for relationships among:

- customers
- orders
- revenue
- order value
- delivery
- reviews

## Metrics Are Starting Points

A metric should often generate the next question.

```text
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

Do not jump directly from metric to recommendation.

---

# 7. Business Mindset

## Purpose

Develop the habit of thinking like an analyst rather than only writing SQL.

## Key Principle

> SQL is a tool. Analytical thinking is the skill.

## Think Business Before SQL

Before writing a query, ask:

- What business question am I answering?
- What decision could this support?
- What business entity should be counted?
- What metric represents the question?
- What evidence would change my conclusion?

## Define the Question First

A useful workflow:

```text
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

## Separate Observation From Conclusion

Example:

**Observation**

> Repeat customers are a small proportion of delivered customers.

**Question**

> What factors might be associated with customers returning?

**Not yet justified**

> A particular factor causes poor retention.

The first two are supported by analysis; the last requires stronger evidence.

## Let Metrics Generate Questions

Do not turn analysis into a checklist of unrelated SQL queries.

Each major analysis should have a reason for existing.

## Validate Assumptions

When a result looks surprising:

1. verify the SQL
2. verify the business definition
3. check the data grain
4. inspect supporting records
5. consider the business process

Do not "fix" a result simply because it is unexpected.

## Think in Systems

Business behaviour usually spans multiple tables.

Understand how:

```text
Customer
   ↓
Order
   ↓
Order Items
   ↓
Product / Seller
   ↓
Delivery / Review
```

Connecting these relationships produces better questions than examining tables independently.

## Technical Decisions Should Support Analysis

Database design, joins, data types and constraints matter because they affect analytical reliability.

## Continuous Improvement

A good analysis can change your earlier assumptions.

That is not failure.

> Strong analysis becomes more precise as evidence accumulates.

---

# 8. Documentation & Project Organization

## Purpose

Documentation should preserve useful thinking without becoming a transcript of the project.

## Key Principle

> Future you should not have to rediscover today's important lessons.

## Separate Documentation by Purpose

| Document | Main purpose |
|---|---|
| README | Explain the project to others |
| Learning Log | Preserve reusable lessons |
| Decision Log | Record important project decisions |
| Roadmap | Track project progress |
| Database Design | Explain schema and relationships |
| Business Health Report | Establish business baseline |
| Final Insights | Present conclusions and recommendations |

Do not make one document responsible for everything.

## Organising SQL

A predictable structure makes analysis easier to navigate.

```text
sql/
├── database setup
├── profiling
└── analysis
```

Use meaningful filenames and keep one analytical purpose per major script where practical.

## Document the Reasoning

Useful documentation answers:

- What did I do?
- Why did I do it?
- What did I learn?
- What should I do differently next time?

Avoid documenting every small action.

---

# 9. Project Evolution

## From Learning SQL to Understanding Databases

SQL syntax was only the beginning.

Effective analysis required understanding:

- entities
- relationships
- table grain
- business processes

## From Tables to Business Processes

Tables are representations of real activities.

For example:

```text
Customer places order
        ↓
Order contains items
        ↓
Seller fulfills order
        ↓
Customer receives order
        ↓
Customer may leave review
```

Thinking in processes makes joins and questions easier to understand.

## From Data Import to Data Trust

Importing data is not the same as trusting it.

Profiling became an essential analytical stage.

## From Writing Queries to Defining Metrics

The important question changed from:

> “What SQL should I write?”

to:

> “What business metric should I define?”

## From Exploration to Investigation

Random exploration can produce interesting numbers without a clear purpose.

A stronger approach is:

```text
Business Question
→ Focused analysis
→ Evidence
→ Insight
→ Recommendation
```

## The General Lesson

The goal of a data analyst is not to produce the largest number of queries.

It is to produce **reliable evidence that helps answer a meaningful business question.**

---

# 10. Customer Retention Analysis

This section records the **reusable analytical lessons** from the Olist retention investigation. Detailed project decisions and exact findings belong in the Decision Log and Final Insights.

## Define the Customer Before Measuring Retention

The entity being counted must match the business question.

For this project:

```text
customer_unique_id
```

was used as the customer entity rather than the individual `customer_id`.

### General lesson

> A metric is only meaningful when its counted entity is clearly defined.

## Define What Counts as a Purchase

An order record is not always identical to a business purchase event.

For this project:

- delivered orders were included
- the customer was identified by `customer_unique_id`
- orders for the same customer with the exact same purchase timestamp were treated as one purchase event
- `DENSE_RANK()` was used to sequence purchase events

### Why this matters

If multiple database rows represent one business event, counting rows can inflate repeat-purchase metrics.

## Establish the Baseline First

The overall repeat-customer rate established the size of the retention problem before investigating possible explanations.

The important lesson is:

> Baseline first, explanation second.

A low repeat rate does not explain itself.

## Analyse the Customer Journey

Instead of stopping at:

> “How many customers repeat?”

ask:

> “What happens between the first and second purchase?”

This led to analysis of:

- time to second purchase
- time to third purchase
- first-purchase characteristics

The first-to-second transition is generally the most important stage when most customers have not yet returned.

## Time-to-Repeat Analysis

Time between purchase events can reveal whether repeat behaviour is:

- immediate
- short-term
- medium-term
- long-term

Use a distribution, not only an average.

Useful statistics include:

- median
- average
- mode
- percentiles
- minimum/maximum
- meaningful time buckets

### Important caution

A duration of `0` days does **not** necessarily mean identical timestamps.

It means the elapsed duration is less than 24 hours when whole-day flooring is used.

## Stage Reach vs Final Purchase Count

These answer different questions.

### Stage reach

> How many customers reached purchase number N?

Useful for customer-journey analysis.

### Final purchase count

> How many customers stopped at exactly N purchases?

Useful for describing the distribution of customers' final observed purchase counts.

Do not confuse the two.

## Investigating First-Purchase Characteristics

Potential factors can be tested against repeat behaviour, such as:

- first-purchase category
- basket size
- category combinations
- delivery experience
- first-purchase order value
- customer location

The purpose is not to prove that one factor causes retention.

The purpose is to determine whether the data provides a useful signal worth pursuing.

## Negative Findings Matter

If delivery time, first-order value, or location does not meaningfully distinguish repeat customers, that is still useful.

It narrows the problem.

> Good analysis is partly about eliminating weak explanations.

## Do Not Force a Driver

If a factor shows only a small difference or unstable results, do not turn it into the main recommendation.

A strong analyst is willing to conclude:

> “This analysis did not provide strong evidence that this factor explains repeat behaviour.”

That is better than inventing a story from weak evidence.

---

# 11. From Analysis to Recommendations

## Recommendation Framework

A recommendation should connect:

```text
Finding
  ↓
Business implication
  ↓
Action / experiment
  ↓
Measurement
```

## Focus on the First-to-Second Purchase Transition

When the largest loss occurs after the first purchase, the strongest strategic focus is often the period immediately following that purchase.

Potential actions should be framed as **tests**, not guaranteed solutions.

Examples of testable directions:

- post-purchase communication
- personalised follow-up
- relevant cross-sell suggestions
- reminders based on likely repurchase timing
- category-specific re-engagement

The analysis alone does not prove which intervention will work.

## Good Recommendation Language

Prefer:

> “Test X because the analysis indicates Y.”

Avoid:

> “X will increase retention.”

The first is evidence-based and appropriately qualified.

## Measure the Recommendation

A recommendation is incomplete without a success metric.

Possible measures:

- second-purchase rate
- time to second purchase
- reactivation rate
- conversion from post-purchase campaign
- incremental revenue

Where possible, compare a test group against a control group.

## Observational Analysis vs Experimentation

The current project is observational.

It can identify patterns and associations.

An experiment is needed to estimate the causal effect of an intervention.

---

# 12. Analytical Discipline & Limitations

## Association Is Not Causation

If customers in one category repeat more often, that does not prove the category causes repeat purchasing.

Possible explanations include:

- customer intent
- product characteristics
- customer demographics
- price
- purchase occasion
- other unmeasured factors

Use language such as:

- associated with
- correlated with
- shows a higher/lower rate
- suggests
- may indicate

Avoid unsupported causal language.

## Small Groups Require Caution

A high percentage from a very small customer group may be unstable.

Always consider:

```text
Rate + Sample Size
```

not rate alone.

Thresholds can help keep comparisons interpretable.

## Definitions Affect Results

Changing any of these can change the answer:

- customer definition
- order status
- purchase-event definition
- time window
- missing-value treatment
- aggregation grain

Therefore:

> Document definitions before comparing metrics.

## Observational Data Has Limits

Historical transactional data can show what happened.

It usually cannot, by itself, establish why something happened or what intervention will definitely work.

## Scope of the Current Analysis

The retention investigation focused on the period around the first purchase and the transition to subsequent purchases.

The analysis should not be presented as a full causal retention model or experimental study.

## Standard for a Strong Final Insight

A strong insight should be:

### 1. Supported by the data

The calculation is correct and validated.

### 2. Relevant to the business question

It helps answer the retention problem.

### 3. Appropriately qualified

The wording matches the strength of the evidence.

## Current Analytical Workflow

Use this as a reusable template for future projects:

```text
1. Understand the business
        ↓
2. Define the business question
        ↓
3. Define entities and metrics
        ↓
4. Understand the data grain
        ↓
5. Profile and validate the data
        ↓
6. Establish a baseline
        ↓
7. Identify an important gap/pattern
        ↓
8. Investigate likely explanations
        ↓
9. Validate findings
        ↓
10. Separate strong findings from weak ones
        ↓
11. Translate findings into recommendations
        ↓
12. Define how recommendations should be measured
```

---

# 13. Quick Reference

## Before Writing SQL

Ask:

- What business question am I answering?
- What entity am I counting?
- What does one row represent?
- What is the correct grain?
- What is the metric definition?
- What should be included/excluded?

## Before Trusting a Result

Check:

- row counts
- joins
- duplicates
- NULLs
- aggregation grain
- denominator
- unexpected values
- business logic

## Before Calling Something an Insight

Ask:

- Is the observation correct?
- Does it answer the business question?
- Is the sample large enough?
- Could another explanation exist?
- Am I confusing association with causation?
- Does this actually change what the business should investigate or do?

## Before Making a Recommendation

Ask:

- What finding supports it?
- Why is the action relevant?
- Is it a proven solution or a testable hypothesis?
- How would success be measured?

## The Core Lesson

> **Good data analysis is not about finding the most interesting number. It is about turning a business question into reliable evidence and knowing how far that evidence allows you to go.**
