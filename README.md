
---

# 📦 Instacart Retail Data Warehouse & Analytics Engineering Pipeline

**Built from scratch: PostgreSQL, SQL, dbt, and Power BI (DirectQuery on 3M+ rows).**

---

## 🚀 Project Purpose

To engineer a retail data warehouse and analytics pipeline—designing every layer (raw, staging, intermediate, marts) from scratch in PostgreSQL, modeling them in dbt Core, and delivering a live Power BI dashboard via DirectQuery.

---

## 🏗️ Architecture Overview

```
Raw CSVs → Python ETL → PostgreSQL (raw schema,indexing and analytics) → SQL transformations → dbt models (marts) → Power BI (DirectQuery dashboard)
```

**(Insert your architecture diagram here)**

---

## 🛠️ Tech Stack

* **Python**: Data loading and preprocessing
* **PostgreSQL**: Data warehouse, schemas, indexing, materialized views,
* **SQL**: Transformation logic, KPI calculations.
* **dbt Core**: Staging, intermediate, and mart models
* **Power BI**: DirectQuery dashboards on 3M+ rows
* **Git**: Version control (~70 commits)

---

## 🗄️ 1. Data Warehouse Design

Engineered a complete warehouse architecture in PostgreSQL with raw, staging, intermediate, and mart layers.
Manually designed schemas, implemented primary/foreign keys, and created materialized views for performance.

**(Insert schema diagram and folder structure screenshots here)**

---

## 🔄 2. SQL Transformations & Optimization

All business logic was crafted in SQL, including joins, KPIs, and aggregations. Optimized performance with indexing and materialized views before layering dbt on top.

**(Insert index and materialized view screenshots here)**

---

## 🧱 3. dbt Modeling

After validating SQL logic, all transformations were modeled in dbt. Developed staging, intermediate, and mart layers with full lineage documentation.

**(Insert dbt lineage graph and model folder screenshots here)**


---

## 📊 4. Power BI Dashboard (DirectQuery)

Built a 3-page Power BI dashboard connected live via DirectQuery to handle 3M+ rows in real-time. Showcased order KPIs, product insights, and user behavior without import mode.

**(Insert full dashboard and key visuals screenshots here)**

---

## 📂 Repository Structure

*(Include your existing folder structure here)*

---

## 📝 How to Run Locally

1. Clone the repo and set up the Python environment.
2. Run ETL notebooks to load data into PostgreSQL.
3. Execute dbt models.
4. Open Power BI and connect via DirectQuery.

---

## 🔧 Future Improvements

* Add dbt tests (uniqueness, relationships)
* Deploy dbt to a scheduler like Airflow
* Add incremental models for larger datasets

---

## 👤 Author

Raga, Aspiring Analytics Engineer | Berlin, Germany

---

This version is concise, highlights the manual engineering work, and is structured for a GitHub audience. Insert your screenshots in the marked spots, and you’re good to go!
