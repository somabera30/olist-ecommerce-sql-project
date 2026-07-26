-- ==========================================
-- Import Data
-- Project: Olist E-commerce SQL Project
-- Purpose: Import CSV files into PostgreSQL
-- ==========================================

-- Customers
\copy customers
FROM 'C:/Users/Admin/Documents/Olist_Ecommerce_SQL_Project/data/olist_customers_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

-- Orders
\copy orders
FROM 'C:/Users/Admin/Documents/Olist_Ecommerce_SQL_Project/data/olist_orders_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

-- Sellers
\copy sellers
FROM 'C:/Users/Admin/Documents/Olist_Ecommerce_SQL_Project/data/olist_sellers_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

-- Products
\copy products
FROM 'C:/Users/Admin/Documents/Olist_Ecommerce_SQL_Project/data/olist_products_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

-- Product Category Translation
\copy product_category_name_translation
FROM 'C:/Users/Admin/Documents/Olist_Ecommerce_SQL_Project/data/product_category_name_translation.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

-- Geolocation
\copy geolocation
FROM 'C:/Users/Admin/Documents/Olist_Ecommerce_SQL_Project/data/olist_geolocation_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'LATIN1'
);

-- Payments
\copy payments
FROM 'C:/Users/Admin/Documents/Olist_Ecommerce_SQL_Project/data/olist_order_payments_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

-- Reviews
\copy reviews
FROM 'C:/Users/Admin/Documents/Olist_Ecommerce_SQL_Project/data/olist_order_reviews_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'LATIN1'
);

-- Order Items
\copy order_items
FROM 'C:/Users/Admin/Documents/Olist_Ecommerce_SQL_Project/data/olist_order_items_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);