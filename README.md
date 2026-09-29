# Vellora E-commerce Analytics

An end-to-end e-commerce analytics project built around a global software retailer selling subscriptions, add-ons, and digital products.

The goal of this project was not just to build a Power BI dashboard. I wanted to take a business problem, translate it into measurable questions, analyze the data using SQL, and present the findings in a way that a business stakeholder could understand quickly.

---

## Business Objective

The business wanted to better understand sales performance and customer purchasing behaviour, with a particular focus on:

- Repeat purchasing and customer retention
- Subscription plans and purchasing behaviour
- Product and category performance
- Sales channels
- Discount usage
- Geographic pricing differences
- Refund behaviour
- Add-on adoption

---

## Business Questions

This analysis was designed to answer the following questions:

- How are sales trending over time?
- Which channels generate the most revenue?
- Which products and categories perform best?
- How common are repeat purchases?
- How quickly do customers make a second purchase?
- Is discount usage associated with repeat purchasing?
- Which products are most popular among repeat customers?
- How do annual and monthly plans compare?
- How strong is add-on adoption?
- How does average order value vary across countries and currencies?
- What are the main reasons behind refunds?

---

## Analytical Approach

I started by understanding the business objective and dataset structure before building the dashboard.

### 1. Data Understanding

- Audited the available tables and key fields.
- Reviewed the event structure and product information.
- Checked customer and product relationships.

### 2. Data Validation

- Checked duplicate event IDs.
- Checked missing customer and product IDs.
- Validated revenue calculations.
- Reviewed event types and refund records.
- Converted the event date from text into a usable date format.

### 3. Business Logic

A key modelling decision was to treat:

- `order` events as new purchases.
- `invoice` events as billing or renewal activity.

Therefore, purchase-based customer metrics such as repeat customers and time to second purchase were calculated using `order` events.

### 4. SQL Analysis

SQL was used to calculate and validate the core business metrics before building the Power BI dashboard.

### 5. Power BI & DAX

The validated metrics were then recreated using DAX and incorporated into an interactive Power BI report.

### 6. Business Insights

The final stage was to translate the analytical results into business-focused findings and areas for further investigation.

---

## Dashboard

The Power BI dashboard is organized into five pages.

### 01 — Executive Overview

Provides a high-level view of:

- Total sales
- Total orders
- Total customers
- Repeat customer rate
- Average order value
- Refund rate
- Monthly sales trends
- Sales by channel
- Top products
- Category performance

### 02 — Customer & Retention

Focuses on customer purchasing behaviour:

- Repeat customers
- Repeat customer rate
- Repeat customer sales share
- Time to second purchase
- Discount users vs non-discount users
- Products purchased by repeat customers
- Repeat-customer product reach

### 03 — Product & Subscription

Analyzes product and subscription behaviour:

- Annual vs monthly plan sales
- Annual vs monthly AOV
- Product category performance
- Top products
- Add-on adoption
- Add-on attach rate

### 04 — Geography & Refunds

Analyzes geographic and refund behaviour:

- Sales by country
- Average order value by country
- Average order value by currency
- Refund rate
- Refunded orders
- Refund reasons

### 05 — Business Insights

Summarizes the most important findings from the analysis and highlights areas that could be investigated further.

---

## Key Findings

- **4,000** customers placed at least one order.
- **3,995** customers placed two or more orders.
- Repeat customer rate was **99.88%**.
- Repeat customers generated **99.98%** of order sales.
- Median time to second purchase was **44 days**.
- **60.9%** of repeat customers made their second purchase within 60 days.
- Discount users had a **99.97%** repeat rate compared with **98.04%** for non-discount users.
- Annual plans generated **$19.84M** compared with **$1.93M** from monthly plans.
- Annual-plan AOV was **$1,212.88** compared with **$116.72** for monthly plans.
- Add-on attach rate was **62.26%**.
- Order-level refund rate was **2.05%**, representing **689 refunded orders**.

These figures describe observed patterns within the dataset. They should not automatically be interpreted as causal relationships. For example, the higher repeat rate among discount users indicates an association, not proof that discounts caused customers to purchase again.

---

## Key Metrics

| Metric | Result |
|---|---:|
| Total Customers | 4,000 |
| Repeat Customers | 3,995 |
| Repeat Customer Rate | 99.88% |
| Repeat Customer Sales Share | 99.98% |
| Median Days to 2nd Purchase | 44 |
| Repeat Customers Purchasing Within 60 Days | 60.9% |
| Annual Plan Sales | $19.84M |
| Monthly Plan Sales | $1.93M |
| Annual Plan AOV | $1,212.88 |
| Monthly Plan AOV | $116.72 |
| Add-on Attach Rate | 62.26% |
| Refund Rate | 2.05% |
| Refunded Orders | 689 |

---

## Tools & Technologies

- **SQL / MySQL** — Data analysis and metric validation
- **Power BI** — Interactive dashboard development
- **DAX** — Analytical measures and business logic
- **Excel** — Dataset inspection and validation
- **Data Visualization** — Business-focused reporting
- **Business Analysis** — Metric definition and insight generation

---

## Repository Structure

```text
Vellora-Ecommerce-Analytics/
│
├── README.md
│
├── documentation/
│   ├── Business_Questions_and_Approach.md
│   ├── Insights_and_Recommendations.md
│   ├── Data_Dictionary.md
│   ├── Data_Quality_Notes.md
│   └── DAX_Measures.md
│
├── sql/
│   └── SQL_Analysis.sql
│
├── powerbi/
│   └── Vellora-Ecommerce-Analytics.pbix
│
├── screenshots/
│
└── assets/

## Documentation

- [Business Questions & Analytical Approach](documentation/Business_Questions_and_Approach.md)
- [Insights & Recommendations](documentation/Insights_and_Recommendations.md)
- [Data Dictionary](documentation/Data_Dictionary.md)
- [Data Quality & Preparation Notes](documentation/Data_Quality_Notes.md)
- [Power BI DAX Measures](documentation/DAX_Measures.md)
- [SQL Analysis](sql/SQL_Analysis.sql)

## Dataset Note

The supplied challenge dataset was relatively clean, so extensive cleaning was not necessary. Most preparation work was validation, date/type conversion, metric definition, and making sure the business logic was applied consistently.

The raw challenge data is not included in this public repository.