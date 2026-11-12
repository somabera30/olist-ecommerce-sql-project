# SQL Scripts

This directory contains all SQL scripts used in the **Olist E-commerce SQL Project**.

The scripts are organized according to the project's analytical workflow, from database creation to business analysis. Each phase builds on the previous one to create a structured and reproducible analysis process.

---

# Workflow

```text
Database Setup
        │
        ▼
Data Profiling & Validation
        │
        ▼
Business Health Assessment
        │
        ▼
Exploratory Data Analysis
        │
        ▼
Business Insights & Recommendations
```

---

# 1. Database Setup

These scripts create the PostgreSQL database and prepare it for analysis.

| File | Purpose |
|------|---------|
| `01_create_database.sql` | Creates the project database. |
| `02_create_tables.sql` | Creates all tables based on the database schema. |
| `03_import_data.sql` | Imports the source datasets into PostgreSQL. |

---

# 2. Data Profiling & Validation

Each dataset is profiled individually before business analysis begins.

The objective is to understand the data, validate its quality, and identify potential issues that could affect later analysis.

Typical validation includes:

- Row count verification
- Missing value analysis
- Duplicate detection
- Identifier validation
- Business rule validation
- Timestamp validation
- Cross-table validation

| File | Dataset |
|------|---------|
| `04_01_customers_profiling.sql` | Customers |
| `04_02_orders_profiling.sql` | Orders |
| `04_03_sellers_profiling.sql` | Sellers |
| `04_04_products_profiling.sql` | Products |
| `04_05_product_category_translation_profiling.sql` | Product Category Translation |
| `04_06_geolocation_profiling.sql` | Geolocation |
| `04_07_payments_profiling.sql` | Payments |
| `04_08_reviews_profiling.sql` | Reviews |
| `04_09_order_items_profiling.sql` | Order Items |

---

# 3. Business Health Assessment

**File**

`05_business_health_report.sql`

This script establishes a baseline understanding of the Olist marketplace using key business metrics.

Rather than answering every business question, the assessment provides an overview of business performance and helps identify areas for deeper investigation.

The report includes KPIs such as:

- Total Revenue
- Delivered Orders
- Average Order Value (AOV)
- Total Customers
- Active Sellers
- Products Sold
- Average Delivery Time
- Average Review Score

Each KPI includes:

- Business objective
- SQL query
- Query output
- Business observation

---

# 4. Exploratory Data Analysis

**File**

`06_customer_retention_analysis.sql`

This phase investigates specific business questions identified during the Business Health Assessment.

The analysis focuses on understanding patterns, relationships, and potential business opportunities using SQL.

---

# 5. Business Insights & Recommendations

**File**

`06_business_insights.md`

[Business Insights: Customer Retention](docs/06_business_insights.md)

This document summarizes the findings from the exploratory analysis and translates them into business insights and actionable recommendations.

---

# Execution Order

Run the SQL scripts in the following sequence:

1. Database Setup
2. Data Profiling & Validation
3. Business Health Assessment
4. Exploratory Data Analysis
5. Business Insights & Recommendations

Each phase depends on the successful completion of the previous one.

---

# Project Philosophy

This project follows a business-oriented analytical workflow rather than treating SQL as a collection of independent queries.

The approach is:

```text
Understand the Dataset
        │
        ▼
Prepare Reliable Data
        │
        ▼
Measure Business Performance
        │
        ▼
Identify Business Questions
        │
        ▼
Perform Focused Analysis
        │
        ▼
Generate Business Insights
```

The goal is not simply to write SQL queries, but to use SQL to understand business performance and support data-driven decision-making.