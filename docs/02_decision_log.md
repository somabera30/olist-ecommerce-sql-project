# Olist E-commerce SQL Project
# Decision Log

 ## Purpose
>
> This document records the key decisions that shaped the design, implementation, and analytical direction of the Olist E-commerce SQL project.
>
> Unlike the Learning Log, it does not explain reusable concepts or technical tutorials.
>
> Instead, it documents the project-specific decisions that required judgment and influenced how the project was built.

---

# Table of Contents

1. Data Modeling Decisions
2. Data Import Decisions
3. Workflow Decisions
4. Business Analysis Decisions
5. Documentation Decisions

---

# How to Read This Document

The **Learning Log** explains **what was learned**.

The **Decision Log** explains **why important project decisions were made**.

Each decision captures:

- the problem or uncertainty,
- the chosen approach,
- the reasoning behind the decision,
- and its impact on the project.

---

# 1. Data Modeling Decisions

## Decision 1 — Use a Composite Primary Key for `order_items`

### Context

The `order_items` table contains multiple items within a single order. The column `order_item_id` restarts from 1 for every order, making it unique only within the scope of that order.

### Decision

Use `(order_id, order_item_id)` as the composite primary key.

### Reasoning

Neither column uniquely identifies a row on its own.

The combination accurately reflects how order items are represented in the business process while preserving row uniqueness.

### Impact

- Prevents duplicate order items.
- Models the business process correctly.
- Supports reliable joins with other transactional tables.

---

## Decision 2 — Do Not Create a Primary Key for `geolocation`

### Context

The geolocation dataset contains duplicate rows and multiple records sharing the same ZIP code prefix.

No single column—or practical combination of columns—can uniquely identify every record.

### Decision

Leave the table without a primary key.

### Reasoning

Adding an artificial key would hide the actual characteristics of the dataset instead of representing them faithfully.

The objective is to preserve the source data rather than force uniqueness where it does not exist.

### Impact

- Maintains fidelity to the original dataset.
- Prevents incorrect assumptions during later analysis.
- Encourages handling duplicate geolocation records explicitly during analytical queries.

---

## Decision 3 — Treat Reference Tables Differently from Transaction Tables

### Context

Reference datasets such as `geolocation` and `product_category_name_translation` serve a different purpose from transactional tables like Orders or Payments.

### Decision

Avoid applying the same validation and constraint strategy used for transactional tables.

### Reasoning

Reference tables provide supporting information rather than recording business events.

Applying identical constraints could create relationships that are not supported by the data.

### Impact

- Produces a more realistic database design.
- Prevents unnecessary or misleading constraints.
- Makes later analytical joins more flexible.

---

# 2. Data Import Decisions

## Decision 4 — Standardize Data Imports Using PostgreSQL `\copy`

### Context

Several methods were available for importing CSV files into PostgreSQL, including pgAdmin's Import Wizard and SQL-based bulk loading.

### Decision

Use PostgreSQL's `\copy` command as the standard import method.

### Reasoning

Using one consistent import workflow improves reproducibility and keeps every dataset import process identical.

It also aligns better with SQL scripts that can be executed repeatedly without relying on graphical interfaces.

### Impact

- Creates a repeatable database setup process.
- Makes the project easier to rebuild.
- Simplifies future automation.

---

## Decision 5 — Preserve the Original Reviews Dataset by Importing with LATIN1 Encoding

### Context

The Reviews dataset failed to import using the default UTF-8 encoding because the source CSV was encoded in LATIN1 (WIN1252).

Several approaches were possible, including modifying the CSV file or changing the import settings.

### Decision

Import the dataset using the correct LATIN1 encoding without modifying the original source file.

### Reasoning

The source dataset should remain unchanged whenever possible.

Adjusting the import process preserves data integrity while accurately handling character encoding.

### Impact

- Original datasets remain untouched.
- Import becomes reproducible.
- Character data is imported correctly without manual file modification.

# 3. Workflow Decisions

## Decision 6 — Separate Data Profiling from Exploratory Data Analysis (EDA)

### Context

Initially, profiling and analysis were performed together. While validating data, it was tempting to immediately interpret business patterns and draw conclusions.

### Decision

Treat Data Profiling and Exploratory Data Analysis as two independent project phases.

### Reasoning

The objective of profiling is to assess data quality and integrity, whereas EDA focuses on understanding business behaviour.

Separating these stages keeps validation objective and prevents business conclusions from being influenced by incomplete or unverified data.

### Impact

- Established a structured analytical workflow.
- Improved the reliability of business insights.
- Made project documentation clearer by separating validation from interpretation.

---

## Decision 7 — Organize SQL Scripts by Project Phase

### Context

As the project grew, a flat collection of SQL files became increasingly difficult to navigate and maintain.

### Decision

Organize SQL scripts according to the project's natural workflow.

Example structure:

- Database Creation
- Table Creation
- Data Import
- Data Profiling
- Business Health Report
- Exploratory Data Analysis
- Business Insights

### Reasoning

Grouping scripts by project phase reflects how the project is actually executed and makes the repository easier to understand.

### Impact

- Improved project navigation.
- Simplified reproduction of the database.
- Created a scalable structure for future analysis.

---

## Decision 8 — Build a Business Health Report Before Detailed Analysis

### Context

Once the database was complete, there were many possible directions for exploration.

Without an initial business overview, exploratory analysis risked becoming a collection of disconnected SQL queries.

### Decision

Create a Business Health Report before beginning detailed Exploratory Data Analysis.

### Reasoning

The Business Health Report establishes a baseline understanding of marketplace performance and helps identify the areas that deserve deeper investigation.

Rather than answering every business question, it helps determine **which questions should be asked next**.

### Impact

- Shifted the project from query-driven exploration to business-driven analysis.
- Provided context for future analytical work.
- Created a structured starting point for Exploratory Data Analysis.

---

# 4. Business Analysis Decisions

## Decision 9 — Define KPI Meaning Before Writing SQL

### Context

Many business metrics can be calculated in multiple valid ways depending on how they are defined.

Writing SQL before defining the metric increases the risk of producing misleading results.

### Decision

Define the business meaning of every KPI before implementing it in SQL.

### Reasoning

SQL is only the implementation.

The business definition determines:

- what should be measured,
- which tables should be used,
- what filters are required,
- and which business entity should be counted.

### Impact

- Produced more consistent KPI calculations.
- Reduced ambiguity in business reporting.
- Encouraged business-first thinking throughout the project.

---

## Decision 10 — Use `customer_unique_id` as the Customer Entity

### Context

The dataset contains both `customer_id` and `customer_unique_id`.

The Business Health Report required a metric representing the number of customers served.

### Decision

Use `customer_unique_id` when calculating customer-level KPIs.

### Reasoning

A single customer may own multiple platform accounts (`customer_id`).

Using `customer_unique_id` better represents individual customers and produces more meaningful customer metrics.

### Impact

- Established a consistent customer definition.
- Improved the accuracy of customer-based KPIs.
- Created a reliable foundation for future customer retention analysis.

---

## Decision 11 — Use the Business Health Report to Prioritize Further Analysis

### Context

The Business Health Report produced many observations about marketplace performance.

Attempting to investigate every observation simultaneously would reduce analytical focus.

### Decision

Use Business Health Report findings to determine the next area of detailed analysis.

### Reasoning

The report should guide analytical priorities rather than act as the final business analysis.

This allows each subsequent investigation to begin with evidence instead of assumptions.

### Impact

- Created a logical progression from overview to deep-dive analysis.
- Prevented random exploration.
- Established a repeatable analytical workflow.

---

## Decision 12 — Separate Observations from Business Conclusions

### Context

Business metrics often reveal interesting patterns, but patterns alone do not explain why they exist.

### Decision

Treat observations and conclusions as separate stages of analysis.

### Reasoning

An observation identifies **what happened**.

A conclusion explains **why it happened**.

### Impact

- Improved analytical objectivity.
- Encouraged evidence-based interpretation.
- Strengthened the quality of business recommendations.

---

# 5. Documentation Decisions

## Decision 13 — Maintain Separate Project Documents for Different Purposes

### Context

As the project expanded, a single document became difficult to maintain and increasingly mixed learning, planning, and implementation details.

### Decision

Separate documentation into independent documents with clearly defined purposes.

The project documentation includes:

- README
- Learning Log
- Decision Log
- Project Roadmap
- Database Design

### Reasoning

Each document answers a different question.

Separating responsibilities reduces duplication and makes information easier to locate.

### Impact

- Improved maintainability.
- Reduced overlap between documents.
- Created a clearer documentation system for future projects.

---

## Decision 14 — Document the Reasoning, Not Just the Implementation

### Context

Recording only completed tasks made it difficult to remember why important choices had been made.

### Decision

Document the reasoning behind significant decisions instead of only recording what was implemented.

### Reasoning

The implementation can usually be understood by reading the SQL.

The reasoning behind the implementation is much easier to forget and often provides greater long-term value.

### Impact

- Made future project reviews easier.
- Preserved the thought process behind key decisions.
- Improved the usefulness of the documentation beyond this project.