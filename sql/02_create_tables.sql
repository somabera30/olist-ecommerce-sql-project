CREATE TABLE customers (
    customer_id TEXT PRIMARY KEY,
    customer_unique_id TEXT NOT NULL,
    customer_zip_code_prefix VARCHAR(5),
    customer_city TEXT NOT NULL,
    customer_state CHAR(2) NOT NULL
);