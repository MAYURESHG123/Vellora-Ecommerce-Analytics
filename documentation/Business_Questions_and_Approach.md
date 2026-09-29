# Business Questions & Analytical Approach

## Understanding the Problem

The dataset represents a global software retailer selling subscriptions, add-ons, services, and other digital products.

The main business problem was to understand what was driving revenue and repeat purchasing, and where there might be opportunities to improve customer retention, cross-selling, and commercial performance.

I treated the challenge as a business analysis problem first and a dashboarding problem second.

## Business Questions

### Sales Performance
- How are sales trending month by month?
- Which sales channels generate the most revenue?
- Which products and categories contribute the most sales?

### Customer Retention
- How many customers make repeat purchases?
- What percentage of customers are repeat customers?
- How much of total sales comes from repeat customers?
- How long does it take a customer to make a second purchase?
- Does discount usage appear to be associated with repeat purchasing?

### Product & Subscription Performance
- Which products have the strongest reach among repeat customers?
- Which products generate the most revenue from repeat customers?
- How do annual and monthly plans compare?
- How different is AOV between annual and monthly plans?
- How many base-product customers also purchase add-ons?

### Geography & Pricing
- Which countries have the highest average order value?
- How does AOV vary across currencies?

### Refund Behaviour
- What percentage of orders are refunded?
- How many orders are refunded?
- What are the most common refund reasons?

## How I Approached the Analysis

### 1. Understand the data
I first looked at the available tables, columns, event types, products, and customers.

### 2. Define what counts as a purchase
The dataset contains both `order` and `invoice` events. I treated `order` as a new purchase and `invoice` as renewal/billing activity. This distinction prevents renewals from being counted as new purchases.

### 3. Validate the data
I checked duplicates, missing identifiers, negative values, event types, revenue calculations, date formatting, and refund fields. The dataset was already relatively clean, so this was mainly validation rather than heavy cleaning.

### 4. Build the SQL analysis
SQL was used to calculate the core metrics and investigate customer, product, subscription, geography, discount, and refund behaviour.

### 5. Analyse customer behaviour
For time-to-second-purchase analysis, the text event date was converted to datetime and orders were chronologically ranked within each customer.

### 6. Compare discount users
Customers were classified as discount users if they had at least one qualifying order with a positive discount. Their repeat rate was then compared with non-discount customers.

This is an observational comparison, so it shows association rather than causation.

### 7. Analyse subscription economics
Annual and monthly plans were compared using sales, order value, and order volume. Revenue and AOV were kept separate because a larger annual transaction does not automatically mean higher profitability.

### 8. Build the Power BI model
After validating the SQL results, I created the Power BI model and DAX measures, then organized the dashboard around the same business questions.

### 9. Turn analysis into insights
The final page focuses on what the numbers mean from a business perspective and what should be investigated next, rather than simply repeating chart values.

## Important Definitions

**Repeat customer:** customer with at least two qualifying `order` events.

**Total sales:** sum of `net_revenue_usd` for qualifying order events.

**Time to second purchase:** difference between the first and second chronological order for each customer.

**Add-on attach rate:** customers who bought at least one add-on divided by customers who bought at least one non-add-on/base product.

**Refund rate:** refunded order events divided by total order events.

## Why SQL Before Power BI?

I used SQL to establish and validate the analytical logic before building the dashboard. SQL answered and checked the business questions, while Power BI/DAX was used to communicate the results interactively.
