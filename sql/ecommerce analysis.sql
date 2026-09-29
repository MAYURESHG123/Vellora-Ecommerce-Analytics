-- DATA DNA E-COMMERCE ANALYTICS — NECESSARY SQL QUERIES
-- Database: datadna_ecommerce
-- Tables: events_raw, products_raw

-- ============================================================
-- 1. SELECT DATABASE
-- USE: Select the project database before running analysis.
-- ============================================================
USE datadna_ecommerce;


-- ============================================================
-- 2. TOTAL ORDERS & SALES
-- USE: Core business KPIs — total purchases and total revenue.
-- ============================================================
SELECT
    COUNT(*) AS total_orders,
    SUM(CAST(net_revenue_usd AS DECIMAL(15,2))) AS total_sales
FROM events_raw
WHERE event_type = 'order';


-- ============================================================
-- 3. MONTHLY SALES TREND
-- USE: Analyze monthly order volume and revenue trends.
-- ============================================================
SELECT
    DATE_FORMAT(
        STR_TO_DATE(event_date, '%d-%m-%Y %H:%i'),
        '%Y-%m'
    ) AS month,
    COUNT(*) AS total_orders,
    SUM(CAST(net_revenue_usd AS DECIMAL(15,2))) AS total_sales
FROM events_raw
WHERE event_type = 'order'
GROUP BY month
ORDER BY month;


-- ============================================================
-- 4. SALES BY CHANNEL
-- USE: Compare order volume and revenue across sales channels.
-- ============================================================
SELECT
    channel,
    COUNT(*) AS total_orders,
    SUM(CAST(net_revenue_usd AS DECIMAL(15,2))) AS total_sales
FROM events_raw
WHERE event_type = 'order'
GROUP BY channel
ORDER BY total_sales DESC;


============================================================
5. TOP PRODUCTS BY REVENUE
USE: Identify the products generating the most revenue.
============================================================
SELECT
    p.product_name,
    p.category,
    COUNT(*) AS order_count,
    SUM(CAST(e.net_revenue_usd AS DECIMAL(15,2))) AS total_sales
FROM events_raw e
JOIN products_raw p
    ON e.product_id = p.product_id
WHERE e.event_type = 'order'
GROUP BY p.product_name, p.category
ORDER BY total_sales DESC;


-- ============================================================
-- 6. REPEAT CUSTOMER RATE
-- USE: Measure the share of customers who made at least 2 orders.
-- ============================================================
WITH repeat_customers AS (
    SELECT customer_id
    FROM events_raw
    WHERE event_type = 'order'
    GROUP BY customer_id
    HAVING COUNT(*) >= 2
),
total_customers AS (
    SELECT COUNT(DISTINCT customer_id) AS total_customers
    FROM events_raw
    WHERE event_type = 'order'
)
SELECT
    COUNT(*) AS repeat_customers,
    total_customers,
    COUNT(*) * 100.0 / total_customers AS repeat_customer_rate
FROM repeat_customers
CROSS JOIN total_customers;


-- ============================================================
-- 7. REPEAT CUSTOMER SALES SHARE
-- USE: Measure how much of total sales comes from repeat customers.
-- ============================================================
WITH repeat_customers AS (
    SELECT customer_id
    FROM events_raw
    WHERE event_type = 'order'
    GROUP BY customer_id
    HAVING COUNT(*) >= 2
)
SELECT
    SUM(CAST(e.net_revenue_usd AS DECIMAL(15,2))) AS repeat_customer_sales,
    (
        SELECT SUM(CAST(net_revenue_usd AS DECIMAL(15,2)))
        FROM events_raw
        WHERE event_type = 'order'
    ) AS total_sales,
    SUM(CAST(e.net_revenue_usd AS DECIMAL(15,2))) * 100.0 /
    (
        SELECT SUM(CAST(net_revenue_usd AS DECIMAL(15,2)))
        FROM events_raw
        WHERE event_type = 'order'
    ) AS repeat_customer_sales_share
FROM events_raw e
JOIN repeat_customers r
    ON e.customer_id = r.customer_id
WHERE e.event_type = 'order';


-- ============================================================
-- 8. MEDIAN TIME TO SECOND PURCHASE
-- USE: Measure how quickly customers make their second purchase.
-- ============================================================
WITH ranked_orders AS (
    SELECT
        customer_id,
        STR_TO_DATE(event_date, '%d-%m-%Y %H:%i') AS event_datetime,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY STR_TO_DATE(event_date, '%d-%m-%Y %H:%i')
        ) AS order_number
    FROM events_raw
    WHERE event_type = 'order'
),
customer_orders AS (
    SELECT
        customer_id,
        MAX(CASE WHEN order_number = 1 THEN event_datetime END) AS first_order,
        MAX(CASE WHEN order_number = 2 THEN event_datetime END) AS second_order
    FROM ranked_orders
    WHERE order_number IN (1,2)
    GROUP BY customer_id
    HAVING second_order IS NOT NULL
),
second_purchase_gap AS (
    SELECT
        DATEDIFF(second_order, first_order) AS days_to_second_purchase
    FROM customer_orders
),
ranked_gap AS (
    SELECT
        days_to_second_purchase,
        ROW_NUMBER() OVER (ORDER BY days_to_second_purchase) AS row_num,
        COUNT(*) OVER () AS total_rows
    FROM second_purchase_gap
)
SELECT
    AVG(days_to_second_purchase) AS median_days_to_second_purchase
FROM ranked_gap
WHERE row_num IN (
    FLOOR((total_rows + 1) / 2),
    FLOOR((total_rows + 2) / 2)
);


-- ============================================================
-- 9. DISCOUNT USAGE VS REPEAT PURCHASE
-- USE: Compare repeat-purchase rates of customers who used discounts
--      versus customers who never used discounts.
-- ============================================================
WITH repeat_customers AS (
    SELECT customer_id
    FROM events_raw
    WHERE event_type = 'order'
    GROUP BY customer_id
    HAVING COUNT(*) >= 2
),
customer_status AS (
    SELECT
        customer_id,
        MAX(
            CASE
                WHEN discount_local > 0 THEN 1
                ELSE 0
            END
        ) AS discount_user,
        CASE
            WHEN customer_id IN (
                SELECT customer_id
                FROM repeat_customers
            ) THEN 1
            ELSE 0
        END AS repeat_customer
    FROM events_raw
    WHERE event_type = 'order'
    GROUP BY customer_id
)
SELECT
    discount_user,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN repeat_customer = 1 THEN 1 ELSE 0 END)
        AS repeat_customers,
    SUM(CASE WHEN repeat_customer = 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*) AS repeat_customer_rate
FROM customer_status
GROUP BY discount_user;


-- ============================================================
-- 10. REFUND RATE
-- USE: Measure the percentage of orders that were refunded.
-- ============================================================
SELECT
    SUM(
        CASE
            WHEN is_refunded = 'TRUE' THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS refund_rate
FROM events_raw
WHERE event_type = 'order';


-- ============================================================
-- 11. REFUND REASONS
-- USE: Identify the main reasons behind refunded orders.
-- ============================================================
SELECT
    refund_reason,
    COUNT(*) AS refunded_orders
FROM events_raw
WHERE event_type = 'order'
  AND is_refunded = 'TRUE'
GROUP BY refund_reason
ORDER BY refunded_orders DESC;


-- ============================================================
-- 12. COUNTRY-WISE AOV
-- USE: Compare average revenue per order across countries.
-- ============================================================
SELECT
    country,
    AVG(CAST(net_revenue_usd AS DECIMAL(15,2))) AS avg_order_value
FROM events_raw
WHERE event_type = 'order'
GROUP BY country
ORDER BY avg_order_value DESC;


-- ============================================================
-- 13. CURRENCY-WISE AOV
-- USE: Compare USD-normalized average revenue per order by currency.
-- ============================================================
SELECT
    currency,
    AVG(CAST(net_revenue_usd AS DECIMAL(15,2))) AS avg_order_value
FROM events_raw
WHERE event_type = 'order'
GROUP BY currency
ORDER BY avg_order_value DESC;


-- ============================================================
-- 14. REPEAT CUSTOMER PRODUCT PERFORMANCE
-- USE: Identify products most popular among repeat customers.
-- ============================================================
WITH repeat_customers AS (
    SELECT customer_id
    FROM events_raw
    WHERE event_type = 'order'
    GROUP BY customer_id
    HAVING COUNT(*) >= 2
)
SELECT
    p.product_name,
    p.category,
    COUNT(*) AS repeat_customer_orders,
    COUNT(DISTINCT e.customer_id) AS repeat_customers,
    SUM(CAST(e.net_revenue_usd AS DECIMAL(15,2)))
        AS repeat_customer_sales
FROM events_raw e
JOIN repeat_customers r
    ON e.customer_id = r.customer_id
JOIN products_raw p
    ON e.product_id = p.product_id
WHERE e.event_type = 'order'
GROUP BY p.product_name, p.category
ORDER BY repeat_customer_sales DESC;


-- ============================================================
-- 15. ANNUAL VS MONTHLY PLAN PERFORMANCE
-- USE: Compare annual and monthly plans by orders, customers,
--      revenue, AOV, and repeat customers.
-- ============================================================
WITH repeat_customers AS (
    SELECT customer_id
    FROM events_raw
    WHERE event_type = 'order'
    GROUP BY customer_id
    HAVING COUNT(*) >= 2
)
SELECT
    p.billing_cycle,
    COUNT(*) AS total_orders,
    COUNT(DISTINCT e.customer_id) AS unique_customers,
    SUM(CAST(e.net_revenue_usd AS DECIMAL(15,2))) AS total_sales,
    AVG(CAST(e.net_revenue_usd AS DECIMAL(15,2))) AS avg_order_value,
    COUNT(DISTINCT CASE
        WHEN r.customer_id IS NOT NULL THEN e.customer_id
    END) AS repeat_customers
FROM events_raw e
JOIN products_raw p
    ON e.product_id = p.product_id
LEFT JOIN repeat_customers r
    ON e.customer_id = r.customer_id
WHERE e.event_type = 'order'
  AND p.billing_cycle IN ('Monthly', 'Annual')
GROUP BY p.billing_cycle
ORDER BY total_sales DESC;


-- ============================================================
-- 16. ADD-ON ATTACH RATE
-- USE: Measure the percentage of base-product customers who also
--      purchased at least one add-on.
-- ============================================================
WITH customer_products AS (
    SELECT
        e.customer_id,
        MAX(CASE
            WHEN p.category = 'Add-on' THEN 1
            ELSE 0
        END) AS bought_addon,
        MAX(CASE
            WHEN p.category <> 'Add-on' THEN 1
            ELSE 0
        END) AS bought_base_product
    FROM events_raw e
    JOIN products_raw p
        ON e.product_id = p.product_id
    WHERE e.event_type = 'order'
    GROUP BY e.customer_id
)
SELECT
    COUNT(CASE
        WHEN bought_base_product = 1 THEN 1
    END) AS base_product_customers,

    COUNT(CASE
        WHEN bought_base_product = 1
         AND bought_addon = 1 THEN 1
    END) AS addon_customers,

    COUNT(CASE
        WHEN bought_base_product = 1
         AND bought_addon = 1 THEN 1
    END) * 100.0 /
    COUNT(CASE
        WHEN bought_base_product = 1 THEN 1
    END) AS addon_attach_rate
FROM customer_products;



WITH repeat_customers AS (
    SELECT customer_id
    FROM events_raw
    WHERE event_type = 'order'
    GROUP BY customer_id
    HAVING COUNT(*) >= 2
)

SELECT
    SUM(CAST(e.net_revenue_usd AS DECIMAL(15,2))) AS repeat_customer_sales,

    (
        SELECT SUM(CAST(net_revenue_usd AS DECIMAL(15,2)))
        FROM events_raw
        WHERE event_type = 'order'
    ) AS total_sales,

    SUM(CAST(e.net_revenue_usd AS DECIMAL(15,2))) * 100.0 /
    (
        SELECT SUM(CAST(net_revenue_usd AS DECIMAL(15,2)))
        FROM events_raw
        WHERE event_type = 'order'
    ) AS repeat_customer_sales_share

FROM events_raw e
JOIN repeat_customers r
    ON e.customer_id = r.customer_id

WHERE e.event_type = 'order';


WITH ranked_orders AS (
    SELECT
        customer_id,
        STR_TO_DATE(event_date, '%d-%m-%Y %H:%i') AS event_datetime,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY STR_TO_DATE(event_date, '%d-%m-%Y %H:%i')
        ) AS order_number
    FROM events_raw
    WHERE event_type = 'order'
),

customer_orders AS (
    SELECT
        customer_id,
        MAX(CASE WHEN order_number = 1 THEN event_datetime END) AS first_order,
        MAX(CASE WHEN order_number = 2 THEN event_datetime END) AS second_order
    FROM ranked_orders
    WHERE order_number IN (1,2)
    GROUP BY customer_id
    HAVING second_order IS NOT NULL
),

purchase_gap AS (
    SELECT
        customer_id,
        DATEDIFF(second_order, first_order) AS days_to_second_purchase
    FROM customer_orders
)

SELECT
    CASE
        WHEN days_to_second_purchase <= 7 THEN '0-7 Days'
        WHEN days_to_second_purchase <= 30 THEN '8-30 Days'
        WHEN days_to_second_purchase <= 60 THEN '31-60 Days'
        WHEN days_to_second_purchase <= 90 THEN '61-90 Days'
        WHEN days_to_second_purchase <= 180 THEN '91-180 Days'
        ELSE '180+ Days'
    END AS purchase_gap_bucket,
    
    COUNT(*) AS customers

FROM purchase_gap

GROUP BY purchase_gap_bucket

ORDER BY
    CASE purchase_gap_bucket
        WHEN '0-7 Days' THEN 1
        WHEN '8-30 Days' THEN 2
        WHEN '31-60 Days' THEN 3
        WHEN '61-90 Days' THEN 4
        WHEN '91-180 Days' THEN 5
        WHEN '180+ Days' THEN 6
    END;
    
    
WITH repeat_customers AS (
    SELECT customer_id
    FROM events_raw
    WHERE event_type = 'order'
    GROUP BY customer_id
    HAVING COUNT(*) >= 2
),

customer_status AS (
    SELECT
        customer_id,

        MAX(
            CASE
                WHEN discount_local > 0 THEN 1
                ELSE 0
            END
        ) AS discount_user,

        CASE
            WHEN customer_id IN (
                SELECT customer_id
                FROM repeat_customers
            )
            THEN 1
            ELSE 0
        END AS repeat_customer

    FROM events_raw
    WHERE event_type = 'order'
    GROUP BY customer_id
)

SELECT
    CASE
        WHEN discount_user = 1 THEN 'Discount User'
        ELSE 'Non-Discount User'
    END AS customer_type,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN repeat_customer = 1 THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    SUM(
        CASE
            WHEN repeat_customer = 1 THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS repeat_customer_rate

FROM customer_status

GROUP BY discount_user
ORDER BY discount_user DESC;

WITH repeat_customers AS (
    SELECT customer_id
    FROM events_raw
    WHERE event_type = 'order'
    GROUP BY customer_id
    HAVING COUNT(*) >= 2
)

SELECT
    p.product_name,
    p.category,
    COUNT(DISTINCT e.customer_id) AS repeat_customers,
    COUNT(*) AS repeat_orders,
    SUM(
        CAST(e.net_revenue_usd AS DECIMAL(15,2))
    ) AS repeat_customer_sales

FROM events_raw e

JOIN repeat_customers r
    ON e.customer_id = r.customer_id

JOIN products_raw p
    ON e.product_id = p.product_id

WHERE e.event_type = 'order'

GROUP BY
    p.product_name,
    p.category

ORDER BY
    repeat_customers DESC
LIMIT 10;