# Olist E-commerce SQL Project
# Learning Log

> ## Purpose
>
> This document is a reusable knowledge base created while building the Olist E-commerce SQL project.
>
> Instead of recording daily activities, it captures the concepts, principles, workflows, and lessons that can be applied to future SQL and database projects.
>
> It is designed to:
>
> - Refresh important SQL and database concepts quickly.
> - Document professional workflows used during the project.
> - Preserve design principles and analytical thinking.
> - Restore project context after long breaks.
> - Provide a reference for building similar relational database projects.

---

# Table of Contents

1. Git & Project Setup
2. Database Design
3. PostgreSQL & Data Import
4. Data Profiling
5. Relational Database Modeling
6. SQL Validation Techniques
7. Documentation & Project Organization
8. Business Mindset
9. Project Journey

---

# 1. Git & Project Setup

## Purpose

Before working with data, establish a project structure that is reproducible, version-controlled, and easy to maintain.

---

## Project Structure

The project was organized into separate folders for:

- SQL scripts
- Datasets
- Documentation
- Database design
- Git repository

Tools used:

- PostgreSQL
- pgAdmin 4
- Visual Studio Code
- Git

Keeping implementation, documentation, and raw datasets separated improves maintainability and makes the project easier to understand.

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

### Key Principles

- Git records the complete history of project changes.
- Each commit should represent one meaningful milestone.
- Commit messages should describe what changed rather than when it changed.
- Version control helps recover previous work and detect accidental modifications.
- SQL scripts and documentation should evolve together so the repository always reflects the current project state.

---

## README

The README serves as the entry point for the project.

It should explain:

- Project objective
- Dataset overview
- Technology stack
- Folder structure
- Steps required to reproduce the project

---

## .gitignore

The repository excludes files that should not be version controlled, including:

- Temporary files
- Editor configuration
- Cache files
- System-generated files

This keeps the repository clean and focused on project assets.

---

# 2. Database Design

## Purpose

Database design should model how a business operates rather than simply mirror the structure of CSV files.

The goal is to create a schema that preserves data integrity, supports efficient analysis, and accurately represents relationships between business entities.

---

## Relational Thinking

Relational databases organize information around business entities rather than storing everything in a single table.

Examples include:

- Customers
- Orders
- Order Items
- Products
- Sellers
- Payments
- Reviews

This approach:

- Reduces data duplication.
- Improves consistency.
- Simplifies maintenance.
- Enables scalable analysis.

---

## Business Understanding Before Table Design

Before creating a table, understand:

- What each row represents.
- What each column represents.
- Whether the table stores transactions, master data, or reference data.
- How the table relates to other entities.

Schema design should follow business meaning rather than assumptions drawn from sample records.

---

## Choosing Appropriate Data Types

Data types should reflect business meaning rather than appearance.

General principles:

- Identifiers → `TEXT`
- ZIP codes → `VARCHAR` or `TEXT`
- Timestamps → `TIMESTAMP`
- State abbreviations → `CHAR(2)`
- Counts and measurements → Integer types when fractional values are impossible.

Identifiers are usually stored as text because arithmetic operations are never performed and formatting (such as leading zeros) must be preserved.

---

## Primary Keys

A Primary Key should:

- uniquely identify a record
- remain stable
- never contain NULL values

Examples:

- customer_id
- order_id

Some datasets may require composite primary keys.

Example:

```
(order_id, order_item_id)
```

because an order can contain multiple items while `order_item_id` only remains unique within each order.

---

## Foreign Keys

Foreign Keys model relationships between business entities.

Instead of memorizing syntax, first ask:

> Can this record exist without its parent?

If the answer is **No**, a foreign key is usually appropriate.

Examples:

- Orders → Customers
- Order Items → Orders
- Order Items → Products
- Order Items → Sellers

Foreign keys improve referential integrity and prevent orphan records.

---

## Parent–Child Relationships

Tables should be created according to dependency order.

Typical workflow:

Parent tables

↓

Child tables

This allows foreign key relationships to be created without dependency issues during import.

---

## Reference Tables vs Transaction Tables

Different tables serve different business purposes.

### Transaction Tables

Record business events.

Examples:

- Orders
- Payments
- Reviews
- Order Items

---

### Master Tables

Store relatively stable business entities.

Examples:

- Customers
- Sellers
- Products

---

### Reference Tables

Provide supporting information used by other datasets.

Examples:

- Geolocation
- Product Category Translation

Reference tables often require different validation strategies and may not always support traditional primary or foreign key constraints.

---

## NULL Handling

NULL constraints should be based on business rules rather than assumptions.

Instead of asking:

> Should this column allow NULL?

Ask:

> Can this event legitimately fail to occur?

Examples:

- Purchase timestamp → No
- Delivery timestamp → Yes
- Approval timestamp → Yes
- Review comments → Yes

Business meaning should determine whether NULL values are acceptable.

---

## Evidence-Based Schema Design

Database constraints should not be created solely from sampled observations.

Recommended workflow:

Business Understanding

↓

Initial Table Design

↓

Import Data

↓

Profile the Complete Dataset

↓

Strengthen Constraints if Supported

This approach avoids making incorrect assumptions before validating the complete dataset.

---

## Schema Evolution

Database schemas are not fixed after table creation.

After profiling:

- Constraints may be added.
- Constraints may be removed.
- Data types may be refined.
- Relationships may be strengthened when supported by evidence.

PostgreSQL supports this iterative design process through `ALTER TABLE`.

---
# 3. PostgreSQL & Data Import

## Purpose

Importing data into a relational database involves more than loading CSV files. A reliable import workflow ensures data integrity, supports reproducibility, and prevents avoidable errors before analysis begins.

---

## Import Workflow

Data should be imported in a structured sequence rather than randomly.

Recommended workflow:

1. Understand the dataset.
2. Design the database schema.
3. Create parent tables.
4. Import parent tables.
5. Create child tables.
6. Import child tables.
7. Validate imported data.
8. Begin data profiling.

Following dependency order prevents foreign key violations and produces a reproducible database setup.

---

## COPY vs `\copy`

Large CSV datasets should be imported using PostgreSQL's bulk import commands instead of multiple `INSERT` statements.

### `COPY`

- Executed by the PostgreSQL server.
- Reads files available to the database server.

### `\copy`

- Executed from the PostgreSQL client.
- Reads files from the local machine.
- Convenient when working from VS Code or the terminal.

For this project, `\copy` became the standard import method because it is faster, easier to automate, and closer to real-world PostgreSQL workflows.

---

## CSV Import Principles

Successful CSV imports require attention to file structure.

Important considerations include:

- Column order
- Delimiters
- Header rows
- Character encoding

Using `CSV HEADER` prevents PostgreSQL from importing column names as data.

---

## Character Encoding

Real-world datasets may not always use UTF-8 encoding.

During this project, the Reviews dataset failed to import because it was encoded in **LATIN1 (WIN1252)** rather than UTF-8.

The issue was resolved by specifying the correct encoding during import.

### Key Lesson

Import failures are not always caused by SQL syntax or database configuration. File encoding should be verified whenever unexpected character errors occur.

---

## Import Validation

After every import, verify that the database matches the source dataset.

Typical validation includes:

- Expected row count
- Import errors
- Missing records
- Basic structural checks

Successful import should always be confirmed before beginning data profiling.

---

# 4. Data Profiling

## Purpose

Data profiling evaluates the quality and reliability of data before it is used for analysis.

Its objective is to determine whether the dataset accurately represents the business process and whether it can be trusted for analytical work.

Profiling answers questions such as:

- Is the data complete?
- Is it consistent?
- Does it satisfy business rules?
- Are relationships between tables valid?

Analysis should only begin after these questions have been answered.

---

## Profiling Workflow

Every table was profiled using a consistent sequence of validation checks.

Standard workflow:

1. Row count validation
2. Missing value analysis
3. Primary key validation
4. Duplicate detection
5. Identifier validation
6. Data format validation
7. Business rule validation
8. Foreign key validation
9. Timestamp validation (where applicable)
10. Summary statistics and distributions

Maintaining the same workflow across every table improves consistency and documentation quality.

---

## Row Count Validation

The first validation confirms that every expected record has been imported successfully.

Matching row counts provide confidence that the import process completed correctly before deeper validation begins.

---

## Missing Value Analysis

NULL values should be interpreted using business context rather than treated as automatic errors.

Examples observed during the project include:

- Review comments may legitimately be missing because customers can submit ratings without writing text.
- Delivery timestamps may be NULL for orders that were never delivered.
- Missing product catalogue attributes may indicate incomplete product registration.

The objective is to distinguish expected missing information from genuine data quality issues.

---

## Identifier Validation

Business identifiers should be validated for:

- uniqueness (when appropriate)
- length
- formatting
- consistency

The project demonstrated that a business identifier is not always a suitable database primary key.

Examples include:

- `review_id`
- `customer_unique_id`

Both require business interpretation before database constraints are applied.

---

## Duplicate Validation

Different types of duplicates have different meanings.

### Duplicate Identifiers

May represent expected business behavior or data quality issues depending on the business process.

### Exact Duplicate Rows

Represent identical records across every column and should be investigated separately.

Treating all duplicates as errors can produce incorrect conclusions.

---

## Foreign Key Validation

Relationships between related tables should always be validated after import.

Typical checks include:

- Every child record references an existing parent.
- No orphan records exist.
- Expected relationships are preserved.

This confirms referential integrity before analytical queries are written.

---

## Timestamp Validation

Chronological data should satisfy expected business sequences.

Examples include:

- Purchase before approval.
- Approval before shipment.
- Shipment before delivery.
- Review creation before review response.

Timestamp validation helps identify inconsistent business events and invalid records.

---

## Measurement Validation

Numeric attributes should be checked against realistic business rules.

Examples include:

- Product dimensions
- Product weight
- Freight values
- Prices
- Photo counts

Unexpected values do not automatically indicate incorrect data but should be documented and interpreted.

---

## Coordinate Validation

Geographical coordinates should satisfy valid Earth ranges.

Validation included:

- Latitude between -90 and 90.
- Longitude between -180 and 180.

Business rules provide an effective way to validate location datasets.

---

## Cross-Table Validation

Profiling should extend beyond individual tables.

Relationships between datasets can reveal missing or inconsistent information.

Examples include:

- Customers without matching geolocation records.
- Sellers without matching geolocation records.
- Orders without valid customers.
- Reviews without valid orders.

Cross-table validation increases confidence in the integrity of the relational database.

---

## Summary Statistics

Basic descriptive statistics provide an overview of numerical attributes before analysis.

Typical metrics include:

- Minimum
- Maximum
- Average
- Distribution
- Frequency counts

These summaries help identify unusual values and guide later exploratory analysis.

---

## Interpreting Profiling Results

Profiling should focus on documenting observations rather than explaining business behavior.

For example:

Observation:

> Some products have zero recorded weight.

Interpretation:

> This may indicate incomplete product information and should be documented for future analysis.

Avoid drawing conclusions such as:

> Sellers intentionally entered incorrect weights.

Such explanations belong to exploratory analysis rather than profiling.

---

# 5. Relational Database Modeling

## Purpose

A relational database should represent business relationships accurately while avoiding unnecessary duplication.

Understanding these relationships is essential for writing reliable SQL queries and producing meaningful analytical results.

---

## Relationship Types

Common relationships encountered during the project included:

- One Customer → Many Orders
- One Order → Many Order Items
- One Product → Many Order Items
- One Seller → Many Order Items

Recognizing relationship cardinality helps determine appropriate keys, joins, and constraints.

---

## Composite Primary Keys

Some tables cannot be uniquely identified by a single column.

When uniqueness depends on multiple attributes, a composite primary key provides a more accurate representation of the business process.

Example:

- (`order_id`, `order_item_id`)

This reflects that item numbers restart within each order.

---

## Reference Datasets

Reference datasets provide supporting information rather than recording business events.

Examples include:

- Geolocation
- Product Category Translation

These tables often require different validation strategies and should not automatically be treated like transactional data.

---

## One-to-Many Join Problems

Joining two tables without considering relationship cardinality can unintentionally multiply rows.

During this project, joining the raw geolocation table directly with customer or seller data produced row multiplication because multiple geolocation records shared the same ZIP code.

Understanding join behavior is essential before performing analysis.

---

## Preparing Data Before Joining

Raw datasets are not always suitable for direct joins.

Depending on the analytical objective, it may be necessary to prepare an intermediate dataset using techniques such as:

- `DISTINCT`
- Aggregation
- Common Table Expressions (CTEs)
- Views

Creating a derived dataset before joining helps avoid duplicated results and produces more reliable analysis.

---

## Key Takeaways

- Relational databases model business relationships rather than spreadsheets.
- Relationship cardinality should guide schema design and SQL joins.
- Reference tables require different treatment from transactional tables.
- Composite keys should reflect business reality instead of forcing artificial uniqueness.
- Understanding relationships is as important as writing SQL syntax.
# 6. Documentation & Project Organization

## Purpose

Good documentation makes a project understandable, reproducible, and maintainable. It should explain not only *what* was implemented, but also *why* decisions were made and how the project is organized.

Documentation should allow another analyst—or your future self—to understand the project without relying on memory.

---

## Documentation Strategy

Project documentation was separated into independent documents, each serving a specific purpose.

| Document        | Purpose                                                                 |
|-----------------|-------------------------------------------------------------------------|
| Learning Log    | Reusable concepts, workflows, and lessons learned                       |
| Decision Log    | Important design and implementation decisions with supporting reasoning |
| Project Roadmap | Current project status, completed milestones, and upcoming work         |
| Database Design | Database schema, relationships, constraints, and ER diagram             |
| README          | Project overview, setup instructions, and repository navigation         |

Separating documentation by purpose keeps each document concise, focused, and easier to maintain.

---

## SQL Project Organization

SQL scripts were organized according to the natural workflow of the project.

```
sql/

01_create_database.sql
02_create_tables.sql
03_import_data.sql

04_data_profiling/
    customers
    orders
    sellers
    products
    ...

05_exploratory_data_analysis.sql

06_business_insights.sql
```

This structure creates a clear execution order while making the repository easier to navigate and extend.

---

## Separating Project Phases

The project was intentionally divided into distinct stages.

1. Database setup
2. Data import
3. Data profiling
4. Exploratory Data Analysis (EDA)
5. Business insights

Each phase has a different objective and should be completed before moving to the next.

---

## Entity Relationship Diagram (ERD)

An Entity Relationship Diagram provides a visual representation of the database structure.

Creating the ERD after finalizing the schema ensures that the diagram reflects the implemented database rather than an initial design draft.

The ERD serves as:

- Documentation
- Relationship reference
- Communication tool
- Schema validation aid

---

## Writing Useful Documentation

Effective documentation explains both implementation and reasoning.

Whenever appropriate, documentation should answer:

- What was done?
- Why was it done?
- What was learned?
- How can this be reused?

Well-written documentation becomes a long-term project asset rather than a record of completed tasks.

---

## Reproducibility

A well-structured project should be reproducible from scratch.

Essential components include:

- Organized SQL scripts
- Version control
- Clear documentation
- Consistent execution order
- Defined project phases

A reproducible project is easier to review, debug, maintain, and share.

---

# 7. Business Mindset

## Think Business Before SQL

SQL is a tool for understanding business processes, not the final objective.

Before writing queries, first understand:

- What business problem is being solved?
- What does each table represent?
- How are business entities related?
- What decisions could this analysis support?

Business understanding should guide every technical decision.

---

## Profile Before Analysis

Data quality should always be evaluated before answering business questions.

Profiling confirms whether the data is reliable enough for analysis.

Skipping this step increases the risk of producing misleading insights.

---

## Separate Profiling from Analysis

Profiling and exploratory analysis have different objectives.

**Data Profiling asks:**

- Is the data complete?
- Is it valid?
- Does it satisfy business rules?

**Exploratory Analysis asks:**

- Why did this happen?
- What patterns exist?
- What business opportunities can be identified?

Keeping these stages separate produces clearer documentation and more reliable conclusions.

---

## Separate Observations from Conclusions

An observation describes what exists in the data.

A conclusion explains why it might exist.

Example:

Observation:

> Four products have a recorded weight of zero.

Conclusion:

> Product information may be incomplete.

Avoid assigning business explanations unless supported by additional evidence.

---

## Validate Before Assuming

Unexpected values should not automatically be treated as errors.

Instead:

- Validate the observation.
- Understand the business context.
- Document the finding.
- Decide whether action is necessary.

Evidence should guide interpretation.

---

## Preserve Source Data

Original datasets should remain unchanged throughout profiling.

Potential issues should be documented rather than corrected unless data cleaning is an explicit project requirement.

Maintaining raw data preserves reproducibility and ensures analytical transparency.

---

## Documentation Is Part of Analysis

Technical work is only valuable if others can understand and reproduce it.

Good analysts document:

- assumptions
- decisions
- validation methods
- interpretations
- limitations

Documentation is an essential component of professional analytical work.

---

## Continuous Improvement

Database design is an iterative process.

As understanding of the data improves:

- constraints may change
- validation methods may improve
- documentation may expand
- analytical questions may evolve

Projects should be refined through evidence rather than assumptions.

---

# 8. Project Journey

## Phase 1 — Environment Setup

Completed:

- Installed PostgreSQL, pgAdmin, VS Code, and Git
- Created the project structure
- Initialized version control
- Prepared repository documentation

---

## Phase 2 — Database Design

Completed:

- Studied the business meaning of each dataset
- Designed normalized database tables
- Defined primary keys, composite keys, and foreign keys
- Reviewed relationships between entities

---

## Phase 3 — Data Import

Completed:

- Imported all project datasets into PostgreSQL
- Resolved import issues such as character encoding
- Validated successful data loading

---

## Phase 4 — Data Profiling

Completed profiling for:

- Customers
- Orders
- Sellers
- Products
- Product Category Translation
- Geolocation
- Payments
- Reviews
- Order Items

Validation included:

- Row counts
- Missing values
- Duplicate detection
- Identifier validation
- Business rule validation
- Foreign key validation
- Timestamp validation
- Cross-table validation

---

## Phase 5 — Database Finalization

Completed:

- Reviewed database schema
- Verified referential integrity
- Created the Entity Relationship Diagram
- Organized SQL scripts
- Structured project documentation

The database is now ready for analytical work.

---

## Current Status

Database development is complete.

The project now consists of:

- A normalized PostgreSQL database
- Validated data quality
- Structured SQL scripts
- Comprehensive documentation
- Version-controlled project files

The next stage focuses entirely on extracting business insights rather than building the database.

---

## Next Phase

Upcoming work includes:

- Exploratory Data Analysis (EDA)
- Advanced SQL queries
- Business insights
- Optional dashboard development
- Final repository polishing
- GitHub publication