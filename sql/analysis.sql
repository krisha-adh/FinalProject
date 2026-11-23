
-- ============================================================================
-- E-Commerce Business Analysis Queries (Schema: ecommerce) FINALLL
-- ============================================================================

-- Q1: Total Carts, Items, and Revenue Overview
-- Question: What is our total cart count, total units in carts, gross value, net value, and customer savings?
SELECT
    COUNT(*) AS total_carts,
    SUM(total_products) AS total_product_lines,
    SUM(total_quantity) AS total_units,
    ROUND(SUM(total)::numeric, 2) AS gross_cart_value,
    ROUND(SUM(discounted_total)::numeric, 2) AS net_discounted_value,
    ROUND(SUM(cart_savings)::numeric, 2) AS total_customer_savings,
    ROUND(AVG(avg_item_value)::numeric, 2) AS avg_item_value_per_cart
FROM ecommerce.carts;


-- Q2: Revenue by Category
-- Question: Which product category brings in the most revenue and units sold?
SELECT
    p.category,
    COUNT(DISTINCT ci.cart_id) AS carts_count,
    SUM(ci.quantity) AS units_sold,
    ROUND(SUM(ci.total)::numeric, 2) AS gross_revenue,
    ROUND(SUM(ci.discounted_total)::numeric, 2) AS net_revenue
FROM ecommerce.cart_items ci
JOIN ecommerce.products p
    ON ci.product_id = p.id
GROUP BY p.category
ORDER BY net_revenue DESC;


-- Q3: Categories with Strong Revenue (WHERE + GROUP BY + HAVING)
-- Question: Which categories have more than $5,000 in discounted line-item revenue?
SELECT
    p.category,
    SUM(ci.quantity) AS units_sold,
    ROUND(SUM(ci.discounted_total)::numeric, 2) AS net_revenue
FROM ecommerce.cart_items ci
JOIN ecommerce.products p
    ON ci.product_id = p.id
WHERE ci.discounted_total > 0
GROUP BY p.category
HAVING SUM(ci.discounted_total) > 5000
ORDER BY net_revenue DESC;


-- Q4: Top Cities by Cart Spend
-- Question: Which cities have the highest total cart spend?
SELECT
    u.city,
    u.country,
    COUNT(c.id) AS carts_count,
    ROUND(SUM(c.discounted_total)::numeric, 2) AS total_spend
FROM ecommerce.users u
JOIN ecommerce.carts c
    ON u.id = c.user_id
GROUP BY u.city, u.country
ORDER BY total_spend DESC
LIMIT 10;


-- Q5: Most Popular Products by Quantity
-- Question: Which products are added to carts in the highest quantities?
SELECT
    p.id AS product_id,
    p.title,
    p.category,
    SUM(ci.quantity) AS total_quantity_sold,
    ROUND(SUM(ci.discounted_total)::numeric, 2) AS net_revenue
FROM ecommerce.cart_items ci
JOIN ecommerce.products p
    ON ci.product_id = p.id
GROUP BY p.id, p.title, p.category
ORDER BY total_quantity_sold DESC
LIMIT 10;


-- Q6: Most Common Brands in Catalog
-- Question: Which brands appear most often in our product catalog?
SELECT
    brand,
    COUNT(*) AS product_count,
    ROUND(AVG(price)::numeric, 2) AS avg_price
FROM ecommerce.products
WHERE brand IS NOT NULL AND TRIM(brand) <> ''
GROUP BY brand
ORDER BY product_count DESC, avg_price DESC
LIMIT 10;


-- Q7: Products Priced Above Overall Average (Subquery)
-- Question: Which products cost more than the average product price across the store?
SELECT
    id,
    title,
    category,
    brand,
    ROUND(price::numeric, 2) AS price,
    ROUND(discounted_price::numeric, 2) AS discounted_price
FROM ecommerce.products
WHERE price > (
    SELECT AVG(price)
    FROM ecommerce.products
)
ORDER BY price DESC;


-- Q8: Top Products Within Each Category (CTE + Window Function)
-- Question: What are the top 3 highest-priced products inside each category?
WITH ranked_by_category AS (
    SELECT
        id,
        title,
        category,
        ROUND(price::numeric, 2) AS price,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY price DESC) AS category_price_rank
    FROM ecommerce.products
)
SELECT
    id,
    title,
    category,
    price,
    category_price_rank
FROM ranked_by_category
WHERE category_price_rank <= 3
ORDER BY category, category_price_rank;


-- Q9: Customer Spend & Spending Tiers (CTE + Window Function)
-- Question: How much does each customer spend overall, and how do they rank?
WITH customer_totals AS (
    SELECT
        u.id AS user_id,
        u.full_name,
        u.city,
        COUNT(c.id) AS cart_count,
        COALESCE(SUM(c.discounted_total), 0) AS total_spend
    FROM ecommerce.users u
    LEFT JOIN ecommerce.carts c
        ON u.id = c.user_id
    GROUP BY u.id, u.full_name, u.city
)
SELECT
    user_id,
    full_name,
    city,
    cart_count,
    ROUND(total_spend::numeric, 2) AS total_spend,
    DENSE_RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
    CASE
        WHEN total_spend >= 5000 THEN 'High'
        WHEN total_spend >= 1500 THEN 'Medium'
        ELSE 'Low'
    END AS spend_level
FROM customer_totals
ORDER BY spend_rank, full_name;


-- Q10: Stock Status & Inventory Value
-- Question: How much inventory value sits in each stock/availability group?
SELECT
    availability_status,
    COUNT(*) AS products_count,
    SUM(stock) AS total_stock_units,
    ROUND(SUM(stock_value)::numeric, 2) AS total_stock_value
FROM ecommerce.products
GROUP BY availability_status
ORDER BY total_stock_value DESC;