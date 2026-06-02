# 🛒 E-Commerce Executive Analytics Pipeline (dbt + Snowflake + Power BI)

[![dbt-Core](https://img.shields.io/badge/dbt-v1.8+-orange.svg)](https://www.getdbt.com/)
[![Snowflake](https://img.shields.io/badge/Snowflake-Cloud_Data_Warehouse-blue.svg)](https://www.snowflake.com/)
[![PowerBI](https://img.shields.io/badge/Power_BI-Online_Reporting-yellow.svg)](https://powerbi.microsoft.com/)

An end-to-end analytics engineering case study building a scalable data infrastructure pipeline. This project ingests raw, localized international e-commerce data, models complex customer behavioral metrics in **Snowflake** using **dbt Cloud**, and delivers polished KPI insights via an executive-ready **Power BI** dashboard.

---

## 📊 Executive Dashboard Preview
> **[🔗 View Live Power BI Interactive Dashboard](YOUR_POWER_BI_SHARE_LINK_HERE)**

[ecom - Power BI.pdf](https://github.com/user-attachments/files/28528637/ecom.-.Power.BI.pdf)

---

## 🛠️ Tech Stack & Architecture

* **Cloud Data Warehouse:** Snowflake (Storage & Compute Engine)
* **Data Transformation & Modeling:** dbt Cloud (Software-engineered SQL)
* **Business Intelligence:** Power BI Service (Executive Data Visualization)
* **Source Data:** ~100k records of multi-table e-commerce transaction schemas

---

## 🚀 Core Analytics Engineering Features

### 1. Advanced Analytical Modeling (Customer Cohorts)
To enable tracking of business retention and customer lifetime metrics, I implemented advanced **SQL Window Functions** to isolate exact customer lifecycle baseline moments directly inside the final dimensional models.

* *Key Logic:* Utilized `MIN() OVER (PARTITION BY ...)` inside `fct_order_details` to determine each user's unique cohort entry timestamp without relying on heavy, un-indexed group-by operations.

### 2. Localization Transformation Layer
Raw source data stored product designations in localized Portuguese text string formats. Built a robust translation lookup schema directly into the dbt transformation flow, dynamically mapping international attributes to standardized corporate English schemas (`PRODUCT_CATEGORY_NAME_ENGLISH`).

---

## 📐 Data Model Pipeline Structure

The dbt project enforces strict modular layering separating staging views from production-grade materializations:

| Layer | Model File | Materialization | Business Purpose |
| :--- | :--- | :--- | :--- |
| **Staging** | `stg_orders.sql` | `view` | Sanitizes types, handles missing values, and renames raw warehouse schemas. |
| **Mart/Fact** | `fct_order_details.sql` | `table` | Executes complex analytical joins, windows customer cohorts, and maps English localizations. |

---

## 📝 Key SQL Showcase: `fct_order_details.sql`
Here is a snapshot of the core analytical engine engineered for this project:

```sql
WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),
translations AS (
    SELECT * FROM {{ ref('stg_product_category_translations') }}
)

SELECT 
    o.order_id,
    o.customer_id,
    o.order_purchase_at,
    -- Advanced Window Function to capture user's initial lifetime purchase moment
    MIN(o.order_purchase_at) OVER(PARTITION BY o.customer_id) AS customer_cohort_date,
    COALESCE(t.product_category_name_english, 'Other') AS product_category_name_english,
    o.total_item_cost
FROM orders o
LEFT JOIN translations t 
    ON o.product_category_name = t.product_category_name<img width="1283" height="720" alt="Screenshot 2026-06-02 at 6 16 34 PM" src="https://github.com/user-attachments/assets/2cd47735-37f8-41d5-83a1-535b75c16932" />
