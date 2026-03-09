USE ROLE SF_INTELLIGENCE_DEMO;
USE WAREHOUSE APP_WH;

-- Row counts
SELECT 'CUSTOMERS' AS table_name, COUNT(*) AS row_count FROM COCO_DEMO.RAW.CUSTOMERS
UNION ALL
SELECT 'ORDERS', COUNT(*) FROM COCO_DEMO.RAW.ORDERS;

-- CUSTOMERS: null counts per column
SELECT
    COUNT(*) - COUNT(customer_id) AS customer_id_nulls,
    COUNT(*) - COUNT(name) AS name_nulls,
    COUNT(*) - COUNT(email) AS email_nulls,
    COUNT(*) - COUNT(region) AS region_nulls,
    COUNT(*) - COUNT(signup_date) AS signup_date_nulls
FROM COCO_DEMO.RAW.CUSTOMERS;

-- CUSTOMERS: distinct value counts
SELECT
    COUNT(DISTINCT customer_id) AS distinct_customer_ids,
    COUNT(DISTINCT name) AS distinct_names,
    COUNT(DISTINCT email) AS distinct_emails,
    COUNT(DISTINCT region) AS distinct_regions,
    MIN(signup_date) AS earliest_signup,
    MAX(signup_date) AS latest_signup
FROM COCO_DEMO.RAW.CUSTOMERS;

-- ORDERS: null counts per column
SELECT
    COUNT(*) - COUNT(order_id) AS order_id_nulls,
    COUNT(*) - COUNT(customer_id) AS customer_id_nulls,
    COUNT(*) - COUNT(order_date) AS order_date_nulls,
    COUNT(*) - COUNT(amount) AS amount_nulls,
    COUNT(*) - COUNT(status) AS status_nulls
FROM COCO_DEMO.RAW.ORDERS;

-- ORDERS: distinct value counts
SELECT
    COUNT(DISTINCT order_id) AS distinct_order_ids,
    COUNT(DISTINCT customer_id) AS distinct_customers,
    COUNT(DISTINCT status) AS distinct_statuses,
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS latest_order,
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount,
    ROUND(AVG(amount), 2) AS avg_amount
FROM COCO_DEMO.RAW.ORDERS;

-- ORDERS: status distribution
SELECT
    status,
    COUNT(*) AS order_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM COCO_DEMO.RAW.ORDERS
GROUP BY status
ORDER BY order_count DESC;

-- CUSTOMERS: region distribution
SELECT
    region,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM COCO_DEMO.RAW.CUSTOMERS
GROUP BY region
ORDER BY customer_count DESC;

SELECT
    c.customer_id,
    c.name,
    c.region,
    COUNT(o.order_id) AS num_orders,
    ROUND(SUM(o.amount), 2) AS total_amount
FROM COCO_DEMO.RAW.CUSTOMERS c
JOIN COCO_DEMO.RAW.ORDERS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.region
ORDER BY total_amount DESC
LIMIT 10;

SELECT
    order_month,
    monthly_revenue,
    order_count,
    ROUND(AVG(monthly_revenue) OVER (
        ORDER BY order_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3m
FROM (
    SELECT
        DATE_TRUNC('month', order_date) AS order_month,
        ROUND(SUM(amount), 2) AS monthly_revenue,
        COUNT(*) AS order_count
    FROM COCO_DEMO.RAW.ORDERS
    GROUP BY order_month
)
ORDER BY order_month;
