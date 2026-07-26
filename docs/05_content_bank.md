# Olist E-commerce SQL Project
# Content Bank

> ## Purpose
>
> This document is a collection of reusable content opportunities discovered while building the project.
>
> It is **not** a repository of finished LinkedIn posts.
>
> Instead, it captures:
>
> - interesting experiences
> - technical decisions
> - business insights
> - project milestones
> - observations worth sharing
>
> Each entry can later become:
>
> - LinkedIn posts
> - Portfolio stories
> - Blog articles
> - Interview examples
>
> The goal is not to document everything.
>
> The goal is to collect experiences that demonstrate analytical thinking and professional project development.

---

# Content Strategy

## Positioning Goal

I want someone reading my LinkedIn posts to gradually conclude that I am:

- a serious entry-level Data Analyst
- business-oriented rather than syntax-oriented
- thoughtful when making technical decisions
- systematic in approaching projects
- committed to data quality before analysis
- capable of explaining both technical work and business reasoning

Every post should reinforce one or more of these qualities.

---

## Content Selection Rule

Before adding a new idea, ask:

> **Will this make a recruiter more confident that I think like a Data Analyst?**

If yes → keep it.

If it is only about SQL syntax without analytical thinking → lower priority.

---

## Posting Priority

When multiple ideas are available, prefer posting in this order:

1. Business thinking
2. Project decisions
3. Project milestones
4. Data quality & validation
5. Technical workflow

The objective is not to appear as someone learning SQL.

The objective is to appear as someone using SQL to understand business data.

---

# 1. Business Thinking

## Understanding the Business Before SQL ⭐⭐⭐⭐⭐

### Hook

> The biggest improvement in my SQL project wasn't learning another query—it was asking better questions.

Raw Notes

- Started by focusing on SQL syntax.
- Gradually realized every table represents a business process.
- Database design begins with understanding the business.
- SQL becomes much easier once the business is understood.

---

## SQL Became an Investigation Tool ⭐⭐⭐⭐☆

Raw Notes

- Initially treated SQL as syntax practice.
- Gradually began using SQL to validate assumptions.
- SQL became a way to understand business processes rather than simply retrieve data.

---

## Thinking in Business Entities ⭐⭐⭐⭐☆

Raw Notes

- Databases organize businesses, not spreadsheets.
- Customers, Orders, Products and Sellers each represent different business entities.
- Relationships became much easier after thinking in terms of the business.

---

## Observations vs Conclusions ⭐⭐⭐⭐☆

Raw Notes

- Profiling should describe observations.
- Business explanations require additional evidence.
- Avoid jumping directly from data to conclusions.

---

# 2. Project Decisions

## ZIP Codes Are Not Numbers ⭐⭐⭐⭐⭐

Raw Notes

- Initially considered INTEGER.
- Realized ZIP codes are identifiers.
- Leading zeros matter.
- Small schema decisions prevent future problems.

---

## Foreign Keys Finally Made Sense ⭐⭐⭐⭐⭐

### Hook

> One question completely changed how I understand foreign keys.

Raw Notes

- "Can this record exist without its parent?"
- Business relationships explain database relationships better than memorizing syntax.

---

## Why I Chose a Composite Primary Key ⭐⭐⭐⭐☆

Raw Notes

- `order_item_id` restarts for every order.
- `(order_id, order_item_id)` reflects the business process.
- Schema design should model reality rather than force artificial uniqueness.

---

## Why I Didn't Create Every Foreign Key ⭐⭐⭐⭐☆

Raw Notes

- Some reference tables don't support reliable relationships.
- Adding every possible foreign key isn't always the correct design choice.
- Database integrity comes before technical completeness.

---

## Why I Started Maintaining a Decision Log ⭐⭐⭐⭐☆

Raw Notes

- Important decisions are easy to forget.
- Recording the reasoning makes future maintenance easier.
- Documentation became part of development instead of an afterthought.

---

# 3. Project Milestones

## Data Profiling Comes Before Dashboards ⭐⭐⭐⭐⭐

### Hook

> I wanted to start analyzing data. Instead, I spent days validating it.

Raw Notes

- Profiling initially felt slow.
- Eventually realized trustworthy insights require trustworthy data.

---

## Completing the Database Development Phase ⭐⭐⭐⭐⭐

Raw Notes

- Designed all tables.
- Imported every dataset.
- Completed profiling.
- Reviewed the schema.
- Created the ER Diagram.
- Organized project documentation.
- Realized building the database is only the foundation for analysis.

---

## Building Like a Professional ⭐⭐⭐⭐☆

Raw Notes

- Used Git throughout the project.
- Maintained Learning Log.
- Maintained Decision Log.
- Structured SQL scripts.
- Focused on reproducibility instead of only completing tasks.

---

# 4. Data Quality & Validation

## Real Data Is Messy—and That's Normal ⭐⭐⭐⭐☆

Raw Notes

- Found timeline inconsistencies.
- Initially assumed SQL mistakes.
- Learned that real datasets naturally contain anomalies.

---

## One Customer, Multiple Accounts ⭐⭐⭐⭐☆

Raw Notes

- Expected `customer_unique_id` to be unique.
- Learned business rules don't always match technical assumptions.

---

## Profiling Taught Me More Than SQL ⭐⭐⭐⭐☆

Raw Notes

- Most valuable learning came from validating data.
- Profiling developed analytical thinking more than syntax memorization.

---

## Character Encoding Matters ⭐⭐⭐☆☆

Raw Notes

- Reviews dataset failed to import.
- Cause: LATIN1 instead of UTF-8.
- Practical problems often require understanding the data source, not just SQL.

---

# 5. Technical Workflow

## Git Saved My Dataset ⭐⭐⭐⭐☆

Raw Notes

- Accidentally modified a CSV.
- Git immediately highlighted the changes.
- Version control protects datasets as well as code.

---

## COPY vs \copy ⭐⭐⭐☆☆

Raw Notes

- Initially assumed INSERT was the normal import method.
- Learned PostgreSQL is optimized for bulk loading with COPY/\copy.

---

## A Repeatable SQL Workflow ⭐⭐⭐⭐☆

Raw Notes

- Understand the dataset.
- Design the schema.
- Import the data.
- Profile the data.
- Perform exploratory analysis.
- Generate business insights.

A repeatable workflow makes projects easier to maintain and reproduce.

---

# Story Inbox

Whenever something happens during the project that makes me stop and think, record it here before deciding whether it belongs in one of the sections above.

Examples:

- "This confused me at first..."
- "I almost made this design mistake..."
- "This one question completely changed my understanding..."
- "This assumption turned out to be wrong..."
- "This business insight surprised me..."