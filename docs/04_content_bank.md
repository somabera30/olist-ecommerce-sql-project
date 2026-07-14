# Olist E-commerce SQL Project
# Content Bank

> **Purpose**
>
> This is a collection of raw content ideas discovered while building the project.
> It is **not** a draft repository. Each entry captures a lesson, mistake, mindset shift, or interesting observation that can later be turned into a LinkedIn post, blog, or portfolio story.

---

# Content Opportunities (Days 1–6)

## Idea 1 ⭐⭐⭐⭐⭐
### Stop Writing SQL. Start Understanding the Business.
**Hook**
> The biggest improvement in my SQL project wasn't learning a new query—it was asking better questions.

**Raw Notes**
- Initially focused on SQL syntax.
- Mentor repeatedly asked: "What does this data represent?"
- Database design starts with business meaning, not SQL.
- This changed how I approach every table.

---

## Idea 2 ⭐⭐⭐⭐⭐
### Data Profiling Comes Before Dashboards
**Hook**
> I wanted to jump into analysis. Instead, I spent days validating data.

**Raw Notes**
- Profiling first felt slow.
- Learned that unreliable data produces unreliable insights.
- Now I treat profiling as part of analysis, not a separate chore.

---

## Idea 3 ⭐⭐⭐⭐☆
### ZIP Codes Are Not Numbers
**Raw Notes**
- Planned to store ZIP codes as integers.
- Realized identifiers are different from measurements.
- Leading zeros matter.
- Small design choices can prevent future bugs.

---

## Idea 4 ⭐⭐⭐⭐☆
### Foreign Keys Finally Made Sense
**Raw Notes**
- Memorizing syntax never helped.
- The question "Can this record exist without its parent?" made everything click.
- Business relationships explain database relationships.

---

## Idea 5 ⭐⭐⭐⭐☆
### Real Data Is Messy—and That's Normal
**Raw Notes**
- Found timeline inconsistencies in orders.
- First thought: SQL mistake.
- Actually: real-world data quality issue.
- Analysts document anomalies before fixing anything.

---

## Idea 6 ⭐⭐⭐⭐☆
### Git Saved My Dataset
**Raw Notes**
- Accidentally modified CSV by opening it in Excel.
- Git immediately showed unexpected changes.
- Learned to use `git diff` and `git restore`.
- Version control isn't just for code.

---

## Idea 7 ⭐⭐⭐⭐☆
### COPY vs INSERT
**Raw Notes**
- Assumed INSERT was the standard import method.
- Learned why PostgreSQL uses COPY/\copy.
- Professional workflows optimize for scale.

---

## Idea 8 ⭐⭐⭐⭐☆
### One Customer, Multiple Accounts
**Raw Notes**
- Expected customer_unique_id to be unique.
- Learned business rules can differ from technical assumptions.
- Data modeling depends on how the business operates.

---

## Idea 9 ⭐⭐⭐☆☆
### SQL Became an Investigation Tool
**Raw Notes**
- SQL started as syntax practice.
- Gradually became a way to validate assumptions and investigate business data.
- Biggest mindset shift so far.

---

## Idea 10 ⭐⭐⭐☆☆
### Building Like a Professional
**Raw Notes**
- Used Git.
- Maintained documentation.
- Created learning and decision logs.
- Followed a structured workflow instead of jumping into analysis.

---

# Weekly Reflection

## Biggest Mindset Shift
Understanding the business is more valuable than memorizing SQL syntax.

## Biggest Technical Lesson
Validate and profile data before analysis.

## Biggest Mistake Avoided
Treating identifiers as numbers and assuming raw data is always correct.

## Best LinkedIn Candidate This Week
1. Data Profiling Comes Before Analysis
2. Stop Writing SQL. Start Understanding the Business.
3. Foreign Keys Finally Made Sense.
