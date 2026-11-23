SELECT
    COUNT(*) AS total_carts,
    ROUND(SUM(total)::numeric, 2) AS gross_cart_value,
    ROUND(SUM(discounted_total)::numeric, 2) AS net_discounted_value,
    ROUND(SUM(cart_savings)::numeric, 2) AS total_savings,
    ROUND(AVG(avg_item_value)::numeric, 2) AS avg_item_value_per_cart
FROM public.carts;

SELECT
    p.category,
    COUNT(DISTINCT ci.cart_id) AS carts_with_category,
    SUM(ci.quantity) AS units_sold,
    ROUND(SUM(ci.total)::numeric, 2) AS gross_item_revenue,
    ROUND(SUM(ci.discounted_total)::numeric, 2) AS net_item_revenue
FROM public.cart_items ci
JOIN public.products p
    ON ci.product_id = p.id
GROUP BY p.category
ORDER BY net_item_revenue DESC;

SELECT
    u.id AS user_id,
    u.full_name,
    u.country,
    u.city,
    COUNT(c.id) AS cart_count,
    SUM(c.total_quantity) AS total_items,
    ROUND(SUM(c.discounted_total)::numeric, 2) AS total_spent,
    ROUND(SUM(c.cart_savings)::numeric, 2) AS total_saved
FROM public.users u
JOIN public.carts c
    ON u.id = c.user_id
GROUP BY u.id, u.full_name, u.country, u.city
ORDER BY total_spent DESC
LIMIT 10;

SELECT
    id,
    title,
    category,
    brand,
    price,
    discounted_price,
    stock,
    ROUND(stock_value::numeric, 2) AS stock_value,
    availability_status
FROM public.products
ORDER BY stock_value DESC
LIMIT 10;


-- ============================================================================
-- E-Commerce Business Analysis Queries (Schema: ecommerce)
-- ============================================================================

-- Q1: Executive Cart & Discount Performance Overview
-- Business Question: How much gross vs. discounted cart value, savings, and average item value do we have overall?
SELECT
    COUNT(*) AS total_carts,
    SUM(total_products) AS total_product_lines,
    SUM(total_quantity) AS total_units,
    ROUND(SUM(total)::numeric, 2) AS gross_cart_value,
    ROUND(SUM(discounted_total)::numeric, 2) AS net_discounted_value,
    ROUND(SUM(cart_savings)::numeric, 2) AS total_customer_savings,
    ROUND(AVG(avg_item_value)::numeric, 2) AS avg_item_value_per_cart
FROM ecommerce.carts;


-- Q2: Top Product Categories by Net Revenue & Units Sold
-- Business Question: Which product categories generate the highest net revenue and unit volume?
SELECT
    COALESCE(NULLIF(TRIM(p.category), ''), 'Uncategorized') AS category,
    COUNT(DISTINCT ci.cart_id) AS carts_count,
    SUM(ci.quantity) AS total_units_sold,
    ROUND(SUM(ci.total)::numeric, 2) AS gross_item_revenue,
    ROUND(SUM(ci.discounted_total)::numeric, 2) AS net_item_revenue
FROM ecommerce.cart_items ci
JOIN ecommerce.products p
    ON ci.product_id = p.id
GROUP BY COALESCE(NULLIF(TRIM(p.category), ''), 'Uncategorized')
ORDER BY net_item_revenue DESC;


-- Q3: High-Value Categories Filtered by Minimum Revenue (WHERE + GROUP BY + HAVING)
-- Business Question: Which categories bring in more than $5,000 in net line-item revenue (excluding zero-price items)?
SELECT
    p.category,
    COUNT(*) AS line_items_count,
    SUM(ci.quantity) AS units_sold,
    ROUND(SUM(ci.discounted_total)::numeric, 2) AS net_revenue
FROM ecommerce.cart_items ci
JOIN ecommerce.products p
    ON ci.product_id = p.id
WHERE ci.discounted_total > 0
GROUP BY p.category
HAVING SUM(ci.discounted_total) > 5000
ORDER BY net_revenue DESC;


-- Q4: Top Cities / Countries by Customer Cart Spend
-- Business Question: Which locations generate the highest total discounted cart value?
SELECT
    COALESCE(NULLIF(TRIM(u.country), ''), 'Unknown') AS country,
    COALESCE(NULLIF(TRIM(u.city), ''), 'Unknown') AS city,
    COUNT(DISTINCT u.id) AS active_shoppers,
    COUNT(c.id) AS carts_count,
    ROUND(SUM(c.discounted_total)::numeric, 2) AS total_cart_spend,
    ROUND(AVG(c.discounted_total)::numeric, 2) AS avg_cart_spend
FROM ecommerce.users u
JOIN ecommerce.carts c
    ON u.id = c.user_id
GROUP BY
    COALESCE(NULLIF(TRIM(u.country), ''), 'Unknown'),
    COALESCE(NULLIF(TRIM(u.city), ''), 'Unknown')
ORDER BY total_cart_spend DESC
LIMIT 15;


-- Q5: Most Frequently Sold / Carted Products & Brands
-- Business Question: Which products and brands appear most often across customer carts?
SELECT
    p.id AS product_id,
    p.title,
    COALESCE(NULLIF(TRIM(p.brand), ''), 'Generic / Unbranded') AS brand,
    p.category,
    COUNT(ci.cart_id) AS cart_appearances,
    SUM(ci.quantity) AS total_quantity,
    ROUND(SUM(ci.discounted_total)::numeric, 2) AS net_revenue
FROM ecommerce.cart_items ci
JOIN ecommerce.products p
    ON ci.product_id = p.id
GROUP BY p.id, p.title, COALESCE(NULLIF(TRIM(p.brand), ''), 'Generic / Unbranded'), p.category
ORDER BY total_quantity DESC, cart_appearances DESC
LIMIT 15;


-- Q6: Above-Average Priced Products (Subquery Comparison)
-- Business Question: Which products are priced above the overall average product price?
SELECT
    id,
    title,
    category,
    brand,
    ROUND(price::numeric, 2) AS price,
    ROUND(discounted_price::numeric, 2) AS discounted_price,
    ROUND(discount_percentage::numeric, 2) AS discount_percentage
FROM ecommerce.products
WHERE price > (
    SELECT AVG(price)
    FROM ecommerce.products
    WHERE price IS NOT NULL
)
ORDER BY price DESC;


-- Q7: Product Price Performance vs. Category Average (CTE + Window Function + CASE)
-- Business Question: How does each product's price compare to its own category average?
WITH category_benchmarks AS (
    SELECT
        id,
        title,
        category,
        brand,
        price,
        AVG(price) OVER (PARTITION BY category) AS category_avg_price,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY price DESC) AS price_rank_in_category
    FROM ecommerce.products
    WHERE price IS NOT NULL
)
SELECT
    id,
    title,
    category,
    brand,
    price_rank_in_category,
    ROUND(price::numeric, 2) AS price,
    ROUND(category_avg_price::numeric, 2) AS category_avg_price,
    ROUND((price - category_avg_price)::numeric, 2) AS diff_from_category_avg,
    CASE
        WHEN price > category_avg_price THEN 'Above Category Avg'
        WHEN price < category_avg_price THEN 'Below Category Avg'
        ELSE 'At Category Avg'
    END AS price_position
FROM category_benchmarks
ORDER BY category, price_rank_in_category;


-- Q8: Customer Spending Tiers & Ranking (CTE + Window Function + CASE)
-- Business Question: How do customers rank by net cart spend, and what spend tier do they fall into?
WITH customer_spend AS (
    SELECT
        u.id AS user_id,
        u.full_name,
        u.country,
        u.city,
        COUNT(c.id) AS cart_count,
        COALESCE(SUM(c.discounted_total), 0) AS total_spend,
        COALESCE(SUM(c.cart_savings), 0) AS total_savings
    FROM ecommerce.users u
    LEFT JOIN ecommerce.carts c
        ON u.id = c.user_id
    GROUP BY u.id, u.full_name, u.country, u.city
)
SELECT
    user_id,
    full_name,
    country,
    city,
    cart_count,
    ROUND(total_spend::numeric, 2) AS total_spend,
    ROUND(total_savings::numeric, 2) AS total_savings,
    DENSE_RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
    CASE
        WHEN total_spend >= 5000 THEN 'High Spender'
        WHEN total_spend >= 1500 THEN 'Mid Spender'
        WHEN total_spend > 0 THEN 'Low Spender'
        ELSE 'No Cart Spend'
    END AS spend_segment
FROM customer_spend
ORDER BY spend_rank, full_name;


-- Q9: Inventory Risk & Stock Value Analysis (WHERE + CASE + Aggregates)
-- Business Question: How much capital is tied up in inventory across availability statuses and stock levels?
SELECT
    COALESCE(NULLIF(TRIM(availability_status), ''), 'Unknown') AS availability_status,
    CASE
        WHEN stock = 0 THEN 'Out of Stock'
        WHEN stock < 20 THEN 'Low Stock (<20)'
        WHEN stock < 50 THEN 'Moderate Stock (20-49)'
        ELSE 'Healthy Stock (50+)'
    END AS stock_bucket,
    COUNT(*) AS product_count,
    SUM(stock) AS total_units_in_stock,
    ROUND(SUM(stock_value)::numeric, 2) AS total_stock_value
FROM ecommerce.products
WHERE stock IS NOT NULL
GROUP BY
    COALESCE(NULLIF(TRIM(availability_status), ''), 'Unknown'),
    CASE
        WHEN stock = 0 THEN 'Out of Stock'
        WHEN stock < 20 THEN 'Low Stock (<20)'
        WHEN stock < 50 THEN 'Moderate Stock (20-49)'
        ELSE 'Healthy Stock (50+)'
    END
ORDER BY total_stock_value DESC;


-- Q10: Cart-Level vs. Line-Item Revenue Reconciliation Check (CTE + JOIN)
-- Business Question: Do cart-level discounted totals match the sum of individual line-item discounted totals?
WITH item_rollups AS (
    SELECT
        cart_id,
        COUNT(*) AS item_rows,
        SUM(quantity) AS sum_item_qty,
        ROUND(SUM(discounted_total)::numeric, 2) AS sum_item_discounted_total
    FROM ecommerce.cart_items
    GROUP BY cart_id
)
SELECT
    c.id AS cart_id,
    c.user_id,
    ROUND(c.discounted_total::numeric, 2) AS cart_discounted_total,
    ir.sum_item_discounted_total,
    ROUND((c.discounted_total - COALESCE(ir.sum_item_discounted_total, 0))::numeric, 2) AS variance,
    CASE
        WHEN ABS(c.discounted_total - COALESCE(ir.sum_item_discounted_total, 0)) < 0.05 THEN 'Matched'
        ELSE 'Variance Detected'
    END AS reconciliation_status
FROM ecommerce.carts c
LEFT JOIN item_rollups ir
    ON c.id = ir.cart_id
ORDER BY ABS(c.discounted_total - COALESCE(ir.sum_item_discounted_total, 0)) DESC, c.id;







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