USE ROLE SF_INTELLIGENCE_DEMO;
USE WAREHOUSE APP_WH;

CREATE OR REPLACE VIEW COCO_DEMO.ANALYTICS.STG_ORDERS AS
SELECT
    o.order_id,
    o.customer_id,
    c.name AS customer_name,
    c.region,
    o.order_date,
    o.amount,
    o.status
FROM COCO_DEMO.RAW.ORDERS o
JOIN COCO_DEMO.RAW.CUSTOMERS c
    ON o.customer_id = c.customer_id
WHERE o.status <> 'cancelled';

CREATE OR REPLACE TABLE COCO_DEMO.ANALYTICS.CUSTOMER_SUMMARY
    CLUSTER BY (region)
AS
SELECT
    c.customer_id,
    c.name AS customer_name,
    c.region,
    c.signup_date,
    COUNT(o.order_id) AS total_orders,
    COALESCE(ROUND(SUM(o.amount), 2), 0) AS total_revenue,
    COALESCE(ROUND(AVG(o.amount), 2), 0) AS avg_order_value,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,
    DATEDIFF('day', MAX(o.order_date), CURRENT_DATE()) AS days_since_last_order
FROM COCO_DEMO.RAW.CUSTOMERS c
LEFT JOIN COCO_DEMO.ANALYTICS.STG_ORDERS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.region, c.signup_date;


