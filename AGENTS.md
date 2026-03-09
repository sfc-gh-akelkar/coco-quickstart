This is a quickstart demo for Cortex Code in Snowsight Workspaces.
The data lives in database COCO_DEMO with schemas RAW and ANALYTICS.

Source tables:
- COCO_DEMO.RAW.CUSTOMERS (customer_id INT, name VARCHAR, email VARCHAR, region VARCHAR, signup_date DATE)
- COCO_DEMO.RAW.ORDERS (order_id INT, customer_id INT, order_date DATE, amount DECIMAL, status VARCHAR)

Conventions:
- Always use fully qualified table names (DATABASE.SCHEMA.TABLE)
- Use APP_WH warehouse and SF_INTELLIGENCE_DEMO role
- Follow Snowflake SQL best practices
