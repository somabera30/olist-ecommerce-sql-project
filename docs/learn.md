# Learning Log — Day 13

## Focus

Continued the exploratory analysis for the customer repeat purchasing objective:

> **How can Olist improve customer retention and repeat purchasing?**

Today's work focused on understanding **when repeat customers make their next purchase** and resolving how to handle orders with the same purchase timestamp.

---

## What I Worked On

### 1. Investigated Orders with the Same Purchase Timestamp

I found that some `customer_unique_id`s had multiple delivered `order_id`s with the exact same `order_purchase_timestamp`.

I initially needed to understand how this should be handled when calculating Time to Second Purchase.

I found:

- **265 unique repeat customers** had multiple delivered orders at the same purchase timestamp.
- This represents approximately **9.5% of the 2,801 repeat customers**.

### Decision

For the **Repeat Customer Rate**:

> Each delivered `order_id` is treated as a separate purchase.

For the **Time-Based Repeat Purchase Analysis**:

> Orders with the same `order_purchase_timestamp` are treated as a single purchase event.

This allows the analysis to measure the time between distinct purchase timestamps without interpreting multiple orders at the exact same timestamp as a meaningful return interval.

---

## 2. Learned About Window Functions for Purchase Sequencing

I explored different window functions for identifying purchase order:

- `RANK()`
- `DENSE_RANK()`
- `ROW_NUMBER()`

I learned that tied timestamps can produce different results depending on the window function.

For the current Time to Second Purchase methodology, grouping by:

- `customer_unique_id`
- `order_purchase_timestamp`

creates distinct purchase events before assigning their sequence.

---

## 3. Calculated Time to Second Purchase

I calculated the time between each customer's:

- First distinct purchase timestamp
- Second distinct purchase timestamp

The analysis included **2,565 customers** with at least two distinct purchase timestamps.

### Results

- **Average time:** 88.86 days
- **Median time:** 41 days
- **Most common time:** Less than 24 hours
- **Maximum time:** 608 days

---

## 4. Improved Time Bucket Calculations

I initially used `ROUND()` when converting timestamp differences into days.

I learned that this could distort the boundaries of time buckets.

I changed the calculation to use `FLOOR()`.

This allowed durations to be interpreted more consistently:

- `0` days → Less than 24 hours
- `1` day → At least 24 hours but less than 48 hours

---

## Time to Second Purchase Distribution

| Time Period | Customers | Percentage |
|---|---:|---:|
| Less than 24 hours | 604 | 23.5% |
| 1–7 days | 186 | 7.3% |
| 8–30 days | 387 | 15.1% |
| 31–90 days | 494 | 19.3% |
| 91–180 days | 412 | 16.1% |
| More than 180 days | 482 | 18.8% |

---

## Analytical Learning

An important lesson from today's analysis was understanding **when to stop investigating**.

Not every interesting pattern needs to be explored further.

For example, although a large proportion of customers made their second distinct purchase within 24 hours, investigating the reason behind this pattern may not directly help answer the main project question.

I decided to continue investigations only when they are likely to help answer:

> **How can Olist improve customer retention and repeat purchasing?**

This helps keep the analysis focused and prevents unnecessary exploration.

---

## Next Step

Continue the repeat purchasing analysis by investigating what happens after the second purchase.

This may include analyzing:

- Time between later consecutive purchases
- Whether purchase timing changes as customers make additional purchases
- Patterns among customers who continue purchasing multiple times

The goal is to understand the broader repeat purchasing journey before investigating potential factors associated with stronger repeat behavior.