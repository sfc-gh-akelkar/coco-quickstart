# coco-quickstart

A quickstart demo for Cortex Code in Snowsight Workspaces. This project sets up a sample customer/orders dataset, builds an analytics pipeline, and creates a Cortex Analyst semantic view for natural language querying.

## Database

All objects live in the `COCO_DEMO` database using the `SF_INTELLIGENCE_DEMO` role and `APP_WH` warehouse.

| Schema | Purpose |
|---|---|
| `RAW` | Source tables with synthetic data |
| `ANALYTICS` | Views, summary tables, and semantic views |

## Files

| File | Description |
|---|---|
| `01_setup_source_data.sql` | Creates the database, schemas, and populates `CUSTOMERS` (500 rows) and `ORDERS` (2000 rows) with synthetic data |
| `02_explore_data.sql` | Data profiling queries: row counts, null checks, distributions, top customers, and monthly revenue trends |
| `03_build_pipeline.sql` | Creates `STG_ORDERS` staging view and `CUSTOMER_SUMMARY` table with clustering |
| `04_create_semantic_view.sql` | Creates the `CUSTOMER_ANALYTICS_SV` semantic view for Cortex Analyst |
| `test_queries.sql` | Ad-hoc analysis with CTEs, window functions, and regional ranking |

## Getting Started

Run the SQL files in order:

1. `01_setup_source_data.sql` — sets up source data
2. `02_explore_data.sql` — explore and validate the data
3. `03_build_pipeline.sql` — build the analytics layer
4. `04_create_semantic_view.sql` — enable natural language queries via Cortex Analyst
