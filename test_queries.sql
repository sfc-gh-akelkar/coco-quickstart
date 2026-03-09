WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.name,
        c.region,
        SUM(o.amount) AS total_spent
    FROM COCO_DEMO.RAW.CUSTOMERS c
    JOIN COCO_DEMO.RAW.ORDERS o USING (customer_id)
    WHERE o.order_date >= DATEADD(days, -90, CURRENT_DATE())
    GROUP BY 1, 2, 3
),
grand_total AS (
    SELECT SUM(total_spent) AS overall_total
    FROM customer_totals
)
SELECT
    ct.customer_id,
    ct.name,
    ct.region,
    ct.total_spent,
    ROUND(ct.total_spent * 100.0 / gt.overall_total, 2) AS pct_of_total,
    RANK() OVER (PARTITION BY ct.region ORDER BY ct.total_spent DESC) AS region_rank,
    ROUND(ct.total_spent * 100.0 / SUM(ct.total_spent) OVER (PARTITION BY ct.region), 2) AS pct_of_region,
    SUM(ct.total_spent) OVER (PARTITION BY ct.region ORDER BY ct.total_spent DESC) AS region_running_total
FROM customer_totals ct
CROSS JOIN grand_total gt
ORDER BY ct.region, region_rank;
