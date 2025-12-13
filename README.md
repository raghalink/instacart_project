
---

# 📦 InstaCart Retail Data Warehouse & Analytics Engineering Pipeline

**PostgreSQL-centric analytics warehouse with SQL semantic layer and Power BI DirectQuery (3M+ rows), plus dbt modeling for transformation documentation and lineage.**


---

## 🚀 Project Objective

To design and deliver a production-style retail analytics warehouse in PostgreSQL, implementing transformation logic as optimized SQL views and materialized views, and serving live Power BI dashboards via DirectQuery.
After validating and optimizing SQL logic at the database layer, dbt was introduced to replicate and document selected transformations, demonstrate staging → intermediate → mart modeling patterns, and generate lineage documentation.

> Note: The primary BI layer consumes PostgreSQL views (including materialized views wrapped as views). dbt models were built to learn and showcase analytics-engineering workflows, not to replace the SQL semantic layer.

---

## 🏗️ Architecture Overview

![pipeline](images/architecture.png)

The pipeline follows a database-first analytics engineering approach. Transformation logic and KPIs were first implemented and optimized as SQL views and materialized views in PostgreSQL to ensure correctness and performance. Power BI consumes these views directly using DirectQuery. dbt was later introduced to replicate selected transformations, apply staging/intermediate/mart modeling patterns, and generate lineage documentation without disrupting the primary BI layer.

---

## 📊 Dataset

This project uses the public [Instacart Online Gorcery Analysis Dataset](https://www.kaggle.com/datasets/yasserh/instacart-online-grocery-basket-analysis-dataset) dataset from Kaggle (3M+ rows of orders,products,order_products,aisles,department).

---

## 🛠️ Tech Stack

* **Python**: Data loading and preprocessing
* **Python packages**: pandas,sqlalchemy,os
* **PostgreSQL**: Data warehouse, schemas, indexing, materialized views,
* **SQL**: Transformation logic, KPI calculations.
* **dbt Core**: Staging, intermediate, and mart models
* **Power BI**: DirectQuery dashboards on 3M+ rows
* **Git**: Version control (~50 commits)
* **Npgsql (.NET PostgreSQL Driver)**: for reliable and high-performance connection between PostgreSQL and Power BI, allowing to use DirectQuery for live dashboards 


---

## 🗄️ 1. Data Warehouse Design

Engineered a PostgreSQL-centric analytics warehouse with clearly separated raw data, base tables, and a SQL semantic layer.

The warehouse schema was manually designed, including primary and foreign key relationships, indexing strategies, and query-optimized structures. Core business logic and KPIs were implemented directly in SQL using views and materialized views, with heavy computations pre-aggregated for performance.

Materialized views were selectively wrapped into standard views to ensure compatibility with Power BI DirectQuery, enabling live dashboards over 3M+ rows while maintaining query performance and stability.

![Schema](images/schema.png)
![views and mvs](images/views_and_mvs.png)

---

## 🔄 2. SQL Transformations & Optimization

All transformation and metric logic was implemented in SQL at the database level to ensure correctness, performance, and reuse across downstream layers. Performance was optimized using indexing and materialized views before introducing dbt for transformation modeling.

---

## 🧱 3. dbt Modeling (Exploration and Documentation layer)

After validating core SQL logic at the database level, selected transformations were replicated and modeled in dbt to learn dbt workflows, layering patterns (staging → intermediate → marts), and lineage generation. The primary BI layer continued to consume optimized database views and materialized views via DirectQuery. Additional details are documented in dbt/README.md.

![dbt lineage graph](images/dbt_graph.png)

---

## 📊 4. Power BI Dashboard (DirectQuery)

The dashboard consumes only prepared PostgreSQL views, avoiding complex DAX and keeping BI logic minimal. A 3-page Power BI dashboard is connected live via DirectQuery to handle 3M+ rows in real time.

![dashboard_pg_1](dashboards/dashboard_1.png)
![dashboard_pg_2](dashboards/dashboard_2.png)
![dashboard_pg_3](dashboards/dashboard_3.png)

---

## 📂 Repository Structure

```text
Retail_Analytics_Engineering_Pipeline/
├── dashboards/
│   ├── dashboard.pbix
│   ├── dashboard.pdf
│   ├── dashboard_1.png
│   ├── dashboard_2.png
│   └── dashboard_3.png
│
├── data_raw/
│   ├── aisles.csv
│   ├── departments.csv
│   ├── orders.csv
│   ├── order_products__prior.csv
│   ├── order_products__train.csv
│   └── products.csv
│
├── data_clean/
│   ├── aisles.csv
│   ├── departments.csv
│   ├── orders.csv
│   ├── order_products.csv
│   └── products.csv
│
├── dbt/
│   ├── dbt_project.yml
│   ├── profiles.yml
│   ├── models/
│   │   ├── staging/
│   │   │   ├── stg_aisles.sql
│   │   │   ├── stg_departments.sql
│   │   │   ├── stg_orders.sql
│   │   │   ├── stg_order_products.sql
│   │   │   └── stg_products.sql
│   │   ├── intermediate/
│   │   │   └── int_order_basket_sizes.sql
│   │   └── mart/
│   │       ├── agg_orders_by_dow.sql
│   │       ├── agg_product_metrics.sql
│   │       ├── fct_kpi_overview.sql
│   │       └── fct_orders_by_dow.sql
│   └── sources.yml
│
├── images/
│   ├── architecture.png
│   ├── dbt_graph.png
│   ├── schema.png
│   └── views_and_mvs.png
│
├── notebooks/
│   ├── 01_explore_raw.ipynb
│   ├── 02_clean_transform.ipynb
│   └── 03_load_to_postgres.ipynb
│
├── sql/
│   ├── 01_schema.sql
│   ├── 02_test_load.sql
│   ├── 03_indexes.sql
│   ├── 04_analytics_queries.sql
│   ├── 05_views.sql
│   ├── 06_materialized_views.sql
│   └── 07_metric_views.sql
│
└── ETL_RUN_LOG.md
```

______________________________________________
---

## 📝 How to Run Locally


1. Clone the repository and set up the Python environment.
2. Run the ETL notebooks to load and clean the raw Instacart data into PostgreSQL.
3. Execute the SQL scripts under `sql/` (schemas, indexes, views, and materialized views) to prepare the analytics layer.
4. Open Power BI and connect to PostgreSQL via DirectQuery to the prepared views.

> Note: dbt models in this repository were developed to replicate and document selected transformations and generate lineage. The Power BI dashboard consumes optimized PostgreSQL views and materialized views directly.

---

## 🔧 Future Improvements

* Expand dbt coverage to fully productionize transformations currently implemented as database views
* Add dbt tests (uniqueness, relationships)
* Deploy dbt using a scheduler such as Airflow
* Introduce incremental models for larger-scale datasets

---

## 👤 Author

Raga, Junior Analytics Engineer | Berlin, Germany

---
