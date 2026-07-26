# Olist E-commerce SQL Project

> **From Raw CSV Files to a Production-Ready PostgreSQL Database**

## Project Overview

This project demonstrates the complete process of transforming raw e-commerce CSV datasets into a structured PostgreSQL relational database for analytical purposes.

Rather than starting directly with data analysis, I focused on building a reliable analytical database by applying database design principles, validating data quality, enforcing relationships, and documenting every design decision before performing business analysis.

This project simulates the real-world workflow of an entry-level Data Analyst responsible for preparing high-quality data for analysis.

---

## Project Highlights

- Designed a relational database consisting of **9 interconnected tables**
- Built the database from scratch using **PostgreSQL**
- Imported and managed **3+ million records** from raw CSV files
- Performed comprehensive **data profiling** for every dataset
- Validated data quality using SQL
- Implemented **Primary Keys**, **Composite Primary Keys**, and **Foreign Keys**
- Identified and documented data quality issues and anomalies
- Created an **Entity Relationship Diagram (ERD)**
- Documented database design decisions and learning throughout the project
- Organized the project following a professional SQL development workflow

---

# Why This Project?

Many SQL portfolio projects begin directly with analytical queries.

In this project, I intentionally focused on building the database first because meaningful analysis depends on reliable, well-structured data.

This project demonstrates the complete workflow of:

- Understanding unfamiliar datasets
- Designing a normalized relational database
- Selecting appropriate data types and constraints
- Importing raw data into PostgreSQL
- Validating data quality
- Maintaining referential integrity
- Documenting design decisions
- Preparing data for Exploratory Data Analysis (EDA)

---

# Dataset

**Dataset:** Olist Brazilian E-commerce Public Dataset

The dataset contains real-world Brazilian e-commerce data, including information about:

- Customers
- Orders
- Sellers
- Products
- Product Categories
- Payments
- Customer Reviews
- Geolocation

The final PostgreSQL database consists of **9 relational tables**.

---

# Tools & Technologies

- PostgreSQL
- pgAdmin 4
- Visual Studio Code
- Git
- GitHub
- SQL

---

# Skills Demonstrated

## SQL

- DDL (CREATE TABLE)
- DML
- Constraints
- Primary Keys
- Composite Primary Keys
- Foreign Keys
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
- Data Modeling
- Entity Relationship Diagram (ERD)
- Referential Integrity
- Normalization

---

## Data Profiling

Performed data quality checks on every table, including:

- Row Count Verification
- Missing Value Analysis
- Duplicate Detection
- Identifier Validation
- Data Type Validation
- Business Rule Validation
- Timestamp Validation
- Foreign Key Validation

---

## Documentation

Maintained project documentation throughout development:

- Learning Logs
- Decision Logs
- Project Roadmap
- Database Design Documentation

---

# Project Workflow

```text
Raw CSV Files
        │
        ▼
Understand Dataset
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
Database Review
        │
        ▼
Entity Relationship Diagram
        │
        ▼
Exploratory Data Analysis (EDA)
        │
        ▼
Business Insights
```

---

# Database Schema

The project contains **9 relational tables**.

| Table | Description |
|--------|-------------|
| customers | Customer information |
| orders | Order details |
| sellers | Seller information |
| products | Product attributes |
| product_category_name_translation | Portuguese-to-English category mapping |
| geolocation | Brazilian ZIP code geolocation data |
| payments | Payment information |
| reviews | Customer reviews |
| order_items | Individual products within each order |

---

# Entity Relationship Diagram

The following diagram represents the implemented PostgreSQL database schema.

![ER Diagram](images/ER_Diagram.png)

---

# Project Structure

```text
Olist_Ecommerce_SQL_Project/
│
├── data/
│
├── docs/
│   ├── 01_learning_log.md
│   ├── 02_decision_log.md
│   ├── 03_project_roadmap.md
│   └── 04_database_design.md
│
├── images/
│   └── ER_Diagram.png
│
├── output/
│
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_import_data.sql
│   ├── 04_01_customers_profiling.sql
│   ├── 04_02_orders_profiling.sql
│   ├── 04_03_sellers_profiling.sql
│   ├── 04_04_products_profiling.sql
│   ├── 04_05_product_category_translation_profiling.sql
│   ├── 04_06_geolocation_profiling.sql
│   ├── 04_07_payments_profiling.sql
│   ├── 04_08_reviews_profiling.sql
│   ├── 04_09_order_items_profiling.sql
│   ├── 05_exploratory_data_analysis.sql
│   └── 06_business_insights.sql
│
├── README.md
└── .gitignore
```

---

# Key Database Design Decisions

- Used **composite primary keys** where a single column could not uniquely identify a record.
- Maintained referential integrity using foreign keys wherever appropriate.
- Kept the **geolocation** table independent because ZIP code prefixes are not unique.
- Treated **product_category_name_translation** as a lookup table without enforcing a foreign key.
- Recognized that **customer_id** identifies a customer record associated with a single order, while **customer_unique_id** identifies the actual customer across multiple purchases.

---

# How to Run

### 1. Clone the repository

```bash
git clone <repository-url>
```

### 2. Open PostgreSQL

Create a new database.

### 3. Execute the SQL scripts in the following order

```text
01_create_database.sql

02_create_tables.sql

03_import_data.sql
```

### 4. Run the profiling scripts

Execute each profiling script to validate the imported data.

### 5. Perform analysis

Run:

- 05_exploratory_data_analysis.sql
- 06_business_insights.sql

---

# Documentation

Detailed project documentation is available in the **docs** folder.

- Learning Log
- Decision Log
- Project Roadmap
- Database Design

---

# Current Project Status

## Phase 1 — Database Development

- ✅ Database Design
- ✅ Schema Creation
- ✅ Data Import
- ✅ Data Profiling
- ✅ Data Validation
- ✅ Entity Relationship Diagram
- ✅ Project Documentation

---

## Phase 2 — Exploratory Data Analysis

**Coming Next**

The next stage of the project will explore business questions related to:

- Customer Behavior
- Sales Performance
- Product Performance
- Seller Performance
- Payment Trends
- Delivery Performance
- Customer Satisfaction

---

# Future Improvements

- Perform advanced SQL-based Exploratory Data Analysis (EDA)
- Generate business insights and recommendations
- Build an interactive Power BI or Tableau dashboard
- Optimize analytical SQL queries
- Create reusable SQL views for reporting

---

# Key Learning Outcomes

Through this project, I strengthened my understanding of:

- Relational Database Design
- PostgreSQL
- SQL Data Definition Language (DDL)
- Data Modeling
- Data Profiling
- Data Validation
- Referential Integrity
- Database Documentation
- Structuring a professional analytics project

---

# About Me

I'm a B.Tech graduate aspiring to build a career in Data Analytics. I enjoy solving business problems through data and continuously improving my skills by working on end-to-end projects with real-world datasets.

Currently, I'm strengthening my expertise in SQL, PostgreSQL, Excel, and Power BI while building a portfolio that demonstrates database design, data validation, and analytical problem-solving.

I'm actively seeking entry-level opportunities in **Data Analytics, Business Intelligence, MIS Reporting, and Operations Analytics**.

---

**Thank you for visiting this repository!**