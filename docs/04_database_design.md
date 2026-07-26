# Database Design

## Objective
Design a normalized relational database for the Olist E-commerce dataset to support SQL querying, exploratory data analysis, and business insights.

## Database Schema
- Customers
- Orders
- Sellers
- Products
- Product Category Translation
- Geolocation
- Payments
- Reviews
- Order Items

## Design Decisions
- Used natural primary keys provided by the dataset where appropriate.
- Used composite primary keys for `payments` and `order_items`.
- Established foreign key relationships to maintain referential integrity.
- Left `geolocation` as an independent table because ZIP code prefixes are not unique.
- Kept `product_category_name_translation` independent because no reliable unique key exists for enforcing a foreign key relationship.

## Entity Relationship Diagram

![ER Diagram](C:\Users\Admin\Documents\Olist_Ecommerce_SQL_Project\images\olist_ecommerce_database_ER_diagram.png)

## Normalization
- Eliminated redundant customer, seller, and product information from transactional tables.
- Stored transactional details in separate tables linked through foreign keys.
- Designed the schema to approximate Third Normal Form (3NF) for analytical querying.

## Conclusion
The resulting schema provides a clean, normalized relational database suitable for data profiling, SQL analysis, and business insight generation.

# Database Design

## Project

**Olist E-commerce SQL Project**

---

# Objective

The objective of this project is to transform the raw Olist e-commerce CSV datasets into a well-structured PostgreSQL relational database suitable for data profiling, exploratory data analysis (EDA), and business insight generation.

The database was designed with an emphasis on:

- Data integrity
- Normalization
- Appropriate data types
- Primary and foreign key relationships
- Efficient analytical querying

---

# Database Schema

The database consists of **nine tables**.

| Table                             | Description                                    |
|-----------------------------------|------------------------------------------------|
| customers                         | Customer information                           |
| orders                            | Order details and delivery timestamps          |
| sellers                           | Seller information                             |
| products                          | Product attributes                             |
| product_category_name_translation | Portuguese-to-English product category mapping |
| geolocation                       | Brazilian ZIP code geolocation data            |
| payments                          | Payment details for each order                 |
| reviews                           | Customer reviews and ratings                   |
| order_items                       | Individual products contained in each order    |

---

# Primary Keys

| Table       | Primary Key                    |
|-------------|--------------------------------|
| customers   | customer_id                    |
| orders      | order_id                       |
| sellers     | seller_id                      |
| products    | product_id                     |
| payments    | (order_id, payment_sequential) |
| order_items | (order_id, order_item_id)      |

The **payments** and **order_items** tables require composite primary keys because a single order can contain multiple payment records and multiple order items.

---

# Foreign Key Relationships

| Child Table | Foreign Key | Parent Table |
|-------------|-------------|--------------|
| orders      | customer_id | customers    |
| payments    | order_id    | orders       |
| reviews     | order_id    | orders       |
| order_items | order_id    | orders       |
| order_items | product_id  | products     |
| order_items | seller_id   | sellers      |

These relationships were validated during data profiling, and no orphan records were found.

---

# Database Design Decisions

## 1. Composite Primary Keys

Composite primary keys were used where a single column could not uniquely identify a record.

### Payments

```
(order_id, payment_sequential)
```

An order may have multiple payment records when customers use more than one payment method.

### Order Items

```
(order_id, order_item_id)
```

An order may contain multiple products, and `order_item_id` is only unique within an order.

---

## 2. Customers and Orders Relationship

Although `orders.customer_id` references `customers.customer_id`, the Olist dataset assigns a unique `customer_id` to each order.

This means:

- Each record in the **customers** table represents the customer information associated with a single order.
- The same real customer may appear multiple times with different `customer_id` values.

To identify repeat customers, the dataset provides:

```
customer_unique_id
```

Therefore:

- `customer_id` identifies a customer record linked to one order.
- `customer_unique_id` identifies the actual customer across multiple orders.

This is a design characteristic of the dataset rather than a limitation of the database.

---

## 3. Geolocation Table

The geolocation table was intentionally left independent.

Reason:

- `geolocation_zip_code_prefix` is **not unique**.
- Multiple latitude and longitude coordinates can exist for the same ZIP code prefix.
- Creating a foreign key from customers or sellers would produce ambiguous relationships.

Instead, the table serves as a reference dataset for geographical analysis.

---

## 4. Product Category Translation

The product category translation table was also kept independent.

Reason:

- It functions as a lookup table.
- No reliable unique constraint exists for enforcing a foreign key relationship.

The table can still be joined during analysis whenever English category names are required.

---

# Entity Relationship Diagram

The following diagram represents the implemented PostgreSQL database schema.

![Entity Relationship Diagram](images/olist_ecommerce_database_ER_diagram.png)

---

# Normalization

The database follows a normalized relational structure.

Key normalization principles include:

- Customer information stored separately from orders.
- Product information stored separately from order items.
- Seller information stored independently.
- Payment records isolated from orders.
- Review records stored independently.
- Transactional data linked using foreign keys.

This minimizes redundancy and improves data consistency.

---

# Database Validation

Before analysis, every table was profiled and validated.

Validation included:

- Row count verification
- Missing value checks
- Duplicate detection
- Primary key validation
- Composite primary key validation
- Foreign key validation
- Data type verification
- Business rule validation
- Timestamp validation

These checks ensured the database was reliable for analytical querying.

---

# Conclusion

The database development phase transformed raw CSV files into a structured PostgreSQL relational database.

The final design provides:

- A normalized schema
- Validated relationships
- Enforced referential integrity where appropriate
- Well-documented design decisions
- A solid foundation for Exploratory Data Analysis (EDA) and business insight generation

The database is now ready for analytical SQL queries and portfolio-quality business analysis.