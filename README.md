
---

📦 RETAIL ANALYTICS ENGINEERING PIPELINE

Python → PostgreSQL (Views + MVs) → dbt Models → Power BI (DirectQuery)

End-to-end analytics engineering pipeline built from scratch (~70 commits to show workflow)

This project is a complete analytics engineering pipeline developed from zero and built entirely using modern data-stack principles.
It processes 3M+ rows sales data from the kaggle  loads them into a PostgreSQL warehouse, builds a semantic layer using views + materialized views, and visualizes insights using a Power BI dashboard connected through DirectQuery.

After the entire SQL logic was validated and production-ready, the project was extended with a full dbt project (staging → intermediate → marts) to demonstrate analytics-engineering best practices and lineage documentation.


---

🚀 Highlights

🔹 Realistic Analytics Engineering Stack

Python (Jupyter) – data cleaning, dtype fixes, combining prior+train datasets,remove test values which have no product_id

PostgreSQL – schema design, indexing, SQL transformations,handling null values like prior_order.

Views + Materialized Views – semantic layer for BI. applied views and materialiyed views to adnle heavier kpi queries and wrapped back into views to feed into BI to keep dashboard performance high and sql logic in SQL.

Power BI (DirectQuery) – high-performance 3 page dashboard over 3M rows Order KPIs,Product Insights, User behaviour and lifecycle management.

dbt – full staging/intermediate/mart models + DAG (lineal graph photos)

Git – ~70 commits to track build process,version control and reporducability



---

🧹 1. Python ETL (Raw → Clean → SQL-ready)

Key steps:

Cleaned raw Instacart CSVs

Standardized datatypes (ints, timestamps)

Merged prior + train datasets

Removed test values from orders since product_id is not present and not needed for the database

Exported clean tables into /data_clean

Logged every ETL step in ETL_RUN_LOG.md


This ensures reproducibility and controlled ingestion into PostgreSQL.


---

🗄️ 2. PostgreSQL Warehouse (Core of the Pipeline)



instacart schema

Clean tables

Views (v_kpi_overview, v_product_metrics, v_user_lifecycle, …)

Materialized Views (mv_product_pair_cooccurrence, mv_next_order_inclusion_probability)


🔥 Performance Engineering

Added indexes for join speed

Used materialized views for heavy KPIs

Wrapped MVs back into views to overcome Power BI DirectQuery fetch limits
(advanced, real-world solution)


This gave you a fully optimized SQL semantic layer before touching dbt.


---

🧱 3. dbt Models (Added After SQL Validation)

After validating the logic at the warehouse level, you migrated the transformations into dbt:

staging/
  stg_orders.sql
  stg_order_products.sql
  stg_products.sql
  stg_aisles.sql

intermediate/
  int_order_lines.sql
  int_basket_sizes.sql

marts/
  agg_orders_by_dow.sql
  agg_product_metrics.sql
  fct_kpi_overview.sql

dbt achievements:

Proper source() definitions

ref()-based model chaining

Full lineage DAG

Analytics-engineering conventions (naming, folders, grain definitions)

analytics_staging, analytics_intermediate, analytics_mart schemas in PostgreSQL



---

⚡ 4. Semantic Layer (Views + MVs + dbt)

Semantic layer covers:

Views for BI:

v_kpi_overview

v_order_lines

v_orders_by_hour

v_orders_by_dow

v_basket_size_by_hour

v_user_order_counts

v_department_metrics


Materialized Views (heavy KPIs):

mv_product_pair_cooccurrence

mv_next_order_inclusion_probability


Wrapped MVs as Views (for Power BI)

v_product_pair_cooccurrence

v_next_order_inclusion_probability


This matches real enterprise BI setups where heavy MVs are exposed as thin views for DirectQuery.


---

📊 5. Power BI Dashboard (DirectQuery – No Import Mode)

One of the strongest parts of your project.

Your dashboard connects directly to PostgreSQL using DirectQuery, meaning:

Always up-to-date

Query pushdown to PostgreSQL

Real warehouse performance

No PowerQuery, no Import mode, no local model


Dashboard Pages (3 pages)

1️⃣ Order KPIs

Total orders, reorder rate, avg basket size

Orders by hour of day

Orders by day of week

Orders by week × hour heatmap


2️⃣ Product Insights

Top sellers & top reorders

Basket size distribution

Product co-occurrence pairs

Basket size by hour


3️⃣ User Behaviour & Lifecycle

Ordering pattern by hour

Ordering pattern by DOW

Basket size evolution across user lifecycle

Customer order frequency distribution


Screenshots are in /dashboards/.

DirectQuery on 3M rows is not common for junior projects — this stands out.


---

🧱 Architecture Diagram

Raw CSVs
   ↓
Python ETL (cleaning, merge, dtype fixes)
   ↓
PostgreSQL Warehouse
   ├── Tables
   ├── Views
   └── Materialized Views
   ↓
dbt (staging → intermediate → marts)
   ↓
Power BI (DirectQuery)
   ↓
Interactive Dashboard (3 pages)


---

📂 Repository Structure

instacart_project/
├── dashboards/
│   ├── dashboard.pbix
│   └── screenshots/
├── data_clean/
├── data_raw/
├── dbt/
│   ├── models/
│   ├── snapshots/
│   └── dbt_project.yml
├── notebooks/
│   ├── 01_explore_raw.ipynb
│   ├── 02_clean_transform.ipynb
│   └── 03_load_to_postgres.ipynb
├── sql/
│   ├── 01_schema.sql
│   ├── 02_indexes.sql
│   ├── 03_views.sql
│   ├── 04_metric_views.sql
│   ├── 05_materialized_views.sql
│   └── 06_analytics_queries.sql
└── ETL_RUN_LOG.md


---

💡 Insights Generated

Some insights enabled by the pipeline:

Strong peak ordering window (10:00–16:00)

Produce department drives the bulk of orders

Reorder behavior shows high customer loyalty

Basket size grows early in user lifecycle then stabilizes

Strong product pair affinities (bananas + avocados, etc.)

Next-order probability increases after repeat purchase



---

🔧 How to Run Locally

1️⃣ Clone repo

git clone https://github.com/raghalink/instacart_project.git
cd instacart_project

2️⃣ Python environment

python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt

3️⃣ Run ETL notebooks

4️⃣ Load into PostgreSQL

5️⃣ Run dbt

cd dbt
dbt debug
dbt run

6️⃣ Open Power BI dashboard

Connect to PostgreSQL using DirectQuery.


---

🧪 Future Improvements

Add dbt tests (unique, not null, relationships)

Add snapshots for SCD tracking

Turn materialized views into incremental models

Deploy dbt to Airflow / Dagster

Add a recommendation engine (affinity analysis)



---

👤 Author

Raga
Aspiring Analytics Engineer — PostgreSQL, dbt, Power BI
Berlin, Germany


---

If you want, I can now also:

✅ Review your GitHub repo formatting
✅ Rewrite your project title
✅ Write the LinkedIn project description
✅ Write your CV bullet points for this project
✅ Build your Rossmann project plan

Just tell me the next step.