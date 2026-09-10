Sure — below is the raw Markdown content. You can copy everything inside the code block directly into a .md file.

# EDA Decision Log

## Customer Repeat Purchase Analysis

### Objective

**Business Question:**

> How can Olist improve customer retention and repeat purchasing?

The analysis focuses on understanding repeat purchasing behavior before investigating potential factors that may influence it.

---

## Decision 1: Analyze Delivered Orders Only

**Decision:**  
Only orders with `order_status = 'delivered'` are included.

**Reason:**  
A delivered order represents a successfully completed purchase.

---

## Decision 2: Define a Repeat Customer

**Decision:**  
A repeat customer is a `customer_unique_id` with more than one delivered `order_id`.

**Reason:**  
`customer_unique_id` represents the actual customer across multiple orders, while `customer_id` can differ for the same customer.

**Result:**  
**2,801 repeat customers**

---

## Decision 3: Use Repeat Customer Rate Instead of Retention Rate

**Decision:**  
Use the term **Repeat Customer Rate**.

### Definition

**Repeat Customer Rate:**

$$
\text{Repeat Customer Rate} =
\frac{\text{Customers with more than one delivered purchase}}
{\text{Total customers with at least one delivered purchase}}
\times 100
$$

**Result:**  
Approximately **3%**

**Reason:**  
The available analysis measures whether customers made another purchase, but does not yet measure retention over a defined time period.

---

## Decision 4: Investigate Time to Second Purchase

After identifying the low repeat customer rate, the next question was:

> How long does it take repeat customers to make another purchase?

The analysis first focuses on the time between the **first and second purchase**.

---

## Decision 5: Handle Orders with the Same Purchase Timestamp

Some repeat customers have multiple delivered `order_id`s with the exact same `order_purchase_timestamp`.

### Finding

- **265** unique repeat customers had multiple delivered orders recorded at the same purchase timestamp.
- This represents approximately **9.5%** of the 2,801 repeat customers.

### Decision for Repeat Customer Rate

Each delivered `order_id` continues to count as a separate purchase.

### Decision for Time-Based Analysis

Orders with the same `order_purchase_timestamp` are treated as a **single purchase event**.

Time to second purchase is therefore calculated between the customer's:

1. First distinct purchase timestamp
2. Second distinct purchase timestamp

**Reason:**  
Multiple orders at the exact same timestamp do not provide a meaningful elapsed interval for measuring return timing.

---

## Decision 6: Time to Second Purchase Population

After grouping orders by distinct purchase timestamps, **2,565 customers** had at least two distinct purchase events.

These customers were included in the **Time to Second Purchase** analysis.

### Time to Second Purchase Findings

| Metric | Result |
|---|---:|
| Most common time | Less than 24 hours |
| Average time | 88.86 days |
| Median time | 41 days |
| Minimum | Less than 24 hours |
| Maximum | 608 days |
| Customers analyzed | 2,565 |

### Distribution

| Time to Second Purchase | Customers | Percentage |
|---|---:|---:|
| Less than 24 hours | 604 | 23.5% |
| 1–7 days | 186 | 7.3% |
| 8–30 days | 387 | 15.1% |
| 31–90 days | 494 | 19.3% |
| 91–180 days | 412 | 16.1% |
| More than 180 days | 482 | 18.8% |

---

## Decision 7: Stop Investigating the Less-Than-24-Hour Group

A notable **23.5%** of customers made their second distinct purchase within 24 hours.

**Decision:**  
Do not investigate the reason for this pattern further at this stage.

**Reason:**  
The current project objective is to understand repeat purchasing and identify useful business insights. Investigating the reason behind every observed pattern may not directly contribute to an actionable retention insight.

Further investigation should only continue when it helps answer the main business question.

---

# Current EDA Progress

## Completed

- Repeat Customer Rate
- Identification of repeat customers
- Handling of same-timestamp orders
- Time to Second Purchase
- Time-to-second-purchase distribution

## Next

Investigate how repeat purchasing behavior changes **after the second purchase**, including the time between later consecutive purchases.