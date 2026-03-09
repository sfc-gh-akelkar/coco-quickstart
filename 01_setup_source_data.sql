USE ROLE SF_INTELLIGENCE_DEMO;
USE WAREHOUSE APP_WH;

CREATE DATABASE IF NOT EXISTS COCO_DEMO;
CREATE SCHEMA IF NOT EXISTS COCO_DEMO.RAW;
CREATE SCHEMA IF NOT EXISTS COCO_DEMO.ANALYTICS;

CREATE OR REPLACE TABLE COCO_DEMO.RAW.CUSTOMERS (
    customer_id INT,
    name VARCHAR,
    email VARCHAR,
    region VARCHAR,
    signup_date DATE
);

CREATE OR REPLACE TABLE COCO_DEMO.RAW.ORDERS (
    order_id INT,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    status VARCHAR
);

INSERT INTO COCO_DEMO.RAW.CUSTOMERS
SELECT
    SEQ4() + 1 AS customer_id,
    'Customer_' || (SEQ4() + 1)::VARCHAR AS name,
    LOWER('customer_' || (SEQ4() + 1)::VARCHAR || '@' ||
        CASE UNIFORM(1, 4, RANDOM())
            WHEN 1 THEN 'gmail.com'
            WHEN 2 THEN 'yahoo.com'
            WHEN 3 THEN 'outlook.com'
            ELSE 'company.com'
        END) AS email,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'North America'
        WHEN 2 THEN 'Europe'
        WHEN 3 THEN 'Asia Pacific'
        WHEN 4 THEN 'Latin America'
        ELSE 'Middle East'
    END AS region,
    DATEADD('day', -UNIFORM(1, 1095, RANDOM()), CURRENT_DATE()) AS signup_date
FROM TABLE(GENERATOR(ROWCOUNT => 500));

INSERT INTO COCO_DEMO.RAW.ORDERS
SELECT
    SEQ4() + 1 AS order_id,
    UNIFORM(1, 500, RANDOM()) AS customer_id,
    DATEADD('day', -UNIFORM(1, 730, RANDOM()), CURRENT_DATE()) AS order_date,
    ROUND(UNIFORM(10, 5000, RANDOM()) + UNIFORM(0, 99, RANDOM()) / 100.0, 2) AS amount,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'pending'
        WHEN 2 THEN 'shipped'
        WHEN 3 THEN 'delivered'
        WHEN 4 THEN 'returned'
        ELSE 'cancelled'
    END AS status
FROM TABLE(GENERATOR(ROWCOUNT => 2000));

SELECT 'CUSTOMERS' AS table_name, COUNT(*) AS row_count FROM COCO_DEMO.RAW.CUSTOMERS
UNION ALL
SELECT 'ORDERS', COUNT(*) FROM COCO_DEMO.RAW.ORDERS;
