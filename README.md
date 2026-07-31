# Olist E-commerce SQL Project

> **From Source Datasets to Business Insights Using PostgreSQL**

---

# Project Overview

This project demonstrates the complete workflow of preparing an e-commerce dataset for business analysis using SQL and PostgreSQL.

Starting with multiple source datasets, I designed a relational database, validated data quality, established meaningful relationships between business entities, and created a Business Health Assessment to understand the overall performance of the Olist marketplace.

Rather than jumping directly into analytical queries, this project emphasizes building a reliable analytical foundation before exploring business questions.

---

# Why This Project?

Many SQL portfolio projects begin with writing analytical queries.

For this project, I wanted to understand the complete process that comes before analysis.

That meant learning how to:

- understand an unfamiliar dataset,
- design a relational database,
- import and validate data,
- identify data quality issues,
- define business metrics,
- and use those metrics to guide further analysis.

This project reflects that learning journey.

---

# Business Objective

The long-term objective of this project is to analyze the Olist marketplace and generate meaningful business recommendations using SQL.

The project follows a structured analytical workflow:

- Build a reliable relational database.
- Validate the quality of the data.
- Establish a business baseline through KPI reporting.
- Identify analytical priorities.
- Perform focused business analysis.

This approach helps ensure that business insights are supported by trustworthy data and clearly defined metrics.

---

# Project Highlights

- Designed a PostgreSQL relational database using **9 interconnected tables**.
- Imported and validated more than **3 million records** from the source datasets.
- Performed comprehensive data profiling for every dataset.
- Applied primary keys, composite primary keys, and foreign keys where appropriate.
- Created an Entity Relationship Diagram (ERD).
- Built a Business Health Assessment using SQL-based KPIs.
- Documented project decisions, learning, and database design throughout development.
- Maintained the project using Git and an organized documentation system.

---

# Dataset

**Dataset:** Olist Brazilian E-commerce Public Dataset

The dataset contains information about:

- Customers
- Orders
- Sellers
- Products
- Product Categories
- Payments
- Reviews
- Geolocation

The PostgreSQL database consists of **9 related tables** designed to support business analysis.

---

# Analytical Workflow

```text
Source Datasets
        │
        ▼
Understand the Dataset
        │
        ▼
Database Design
        │
        ▼
Create PostgreSQL Tables
        │
        ▼
Import Data
        │
        ▼
Data Profiling & Validation
        │
        ▼
Business Health Assessment
        │
        ▼
Identify Business Questions
        │
        ▼
Focused Exploratory Data Analysis
        │
        ▼
Business Insights
        │
        ▼
Recommendations
```

---

# Tools & Technologies

- PostgreSQL
- pgAdmin 4
- SQL
- Git
- GitHub
- Visual Studio Code

---

# Skills Demonstrated

## SQL

- DDL (CREATE TABLE)
- DML
- JOINs
- Aggregate Functions
- GROUP BY
- HAVING
- Common Table Expressions (CTEs)
- Data Validation Queries

---

## Database Design

- Relational Database Design
- Schema Design
- Entity Relationships
- Constraints
- Primary Keys
- Composite Primary Keys
- Foreign Keys

---

## Data Quality

- Data Profiling
- Missing Value Analysis
- Duplicate Detection
- Business Rule Validation
- Timestamp Validation
- Cross-table Validation

---

## Business Analysis

- KPI Definition
- Business Health Assessment
- Business Entity Identification
- Business Question Framing
- Analytical Workflow

---

## Documentation

- Learning Log
- Decision Log
- Database Design Documentation
- Project Roadmap
- Business Health Report

---

# Database Schema

The project contains nine related tables representing different parts of the Olist marketplace.

| Table | Description |
|--------|-------------|
| customers | Customer information |
| orders | Order details |
| sellers | Seller information |
| products | Product information |
| product_category_name_translation | Category translation |
| geolocation | ZIP code geolocation data |
| payments | Payment information |
| reviews | Customer reviews |
| order_items | Products within each order |

---

# Entity Relationship Diagram

The following diagram represents the implemented PostgreSQL database schema.

```markdown
![ER Diagram](images/ER_Diagram.png)
```

---

# Project Structure

```text
Olist_Ecommerce_SQL_Project/
│
├── data/
├── docs/
├── images/
├── output/
├── sql/
├── README.md
└── .gitignore
```

---

# Documentation

The project documentation explains both the implementation and the thinking behind the project.

| Document | Purpose |
|----------|---------|
| Learning Log | Concepts and analytical thinking developed during the project |
| Decision Log | Important project decisions and their reasoning |
| Database Design | Schema design, relationships and ER Diagram |
| Business Health Report | KPI-based assessment of business performance |
| Project Roadmap | Current progress and upcoming work |

---

# Current Status

## ✅ Phase 1 — Database Development

Completed:

- Database Design
- Data Import
- Data Profiling
- Data Validation
- Entity Relationship Diagram
- Documentation

---

## ✅ Phase 2 — Business Health Assessment

Completed:

- KPI Definition
- Business Health Report
- Initial Business Observations
- Identification of the next analytical focus

---

## 🚀 Phase 3 — Customer Retention Analysis

Next phase:

- Define customer retention metrics.
- Analyze repeat purchasing behaviour.
- Identify factors influencing customer retention.
- Develop business recommendations.

---

# Future Work

- Complete Customer Retention Analysis.
- Perform additional business analyses.
- Build an interactive Power BI dashboard.
- Publish the completed project portfolio.

---

# Key Learning Outcomes

Through this project, I developed a deeper understanding of:

- Relational database design
- SQL with PostgreSQL
- Data profiling and validation
- Business-oriented data analysis
- KPI definition
- Documentation and project organization
- Structuring an end-to-end SQL project

---

# About Me

I'm a B.Tech graduate building a career in Data Analytics.

I enjoy understanding business problems through data and continuously improving my skills by working on practical projects with real-world datasets.

Currently, I'm strengthening my skills in SQL, PostgreSQL, Excel, and Power BI while building a portfolio that demonstrates database design, data validation, and business analysis.

I'm actively seeking entry-level opportunities in Data Analytics, Business Intelligence, MIS Reporting, and Operations Analytics.

---

**Thank you for visiting this repository!**