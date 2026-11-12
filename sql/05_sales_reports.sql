-- =============================================================
-- File 05: Sales analysis and business reports
-- Skills: SUM, COUNT, AVG, GROUP BY, HAVING, subqueries,
--         CASE, date functions, CTEs, window functions
--
-- Rule used in every sales report:
--   Cancelled orders are NOT counted as sales.
-- =============================================================
USE online_shop;

-- -------------------------------------------------------------
-- R1. Total sales (revenue) for the whole store
-- -------------------------------------------------------------
SELECT ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_sales
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled';

-- -------------------------------------------------------------
-- R2. Store summary: orders, items sold, revenue, average order
-- -------------------------------------------------------------
SELECT COUNT(DISTINCT o.order_id)                          AS total_orders,
       SUM(oi.quantity)                                    AS items_sold,
       ROUND(SUM(oi.quantity * oi.unit_price), 2)          AS total_revenue,
       ROUND(SUM(oi.quantity * oi.unit_price)
             / COUNT(DISTINCT o.order_id), 2)              AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled';

-- -------------------------------------------------------------
-- R3. Top 5 best-selling products (by quantity sold)
-- -------------------------------------------------------------
SELECT p.product_name,
       SUM(oi.quantity)                           AS units_sold,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders   o ON oi.order_id   = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC, revenue DESC
LIMIT 5;

-- -------------------------------------------------------------
-- R4. Top 5 products by revenue (money earned)
-- -------------------------------------------------------------
SELECT p.product_name,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders   o ON oi.order_id   = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 5;

-- -------------------------------------------------------------
-- R5. Sales by category
-- -------------------------------------------------------------
SELECT c.category_name,
       SUM(oi.quantity)                           AS units_sold,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM order_items oi
JOIN products   p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders     o ON oi.order_id   = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.category_id, c.category_name
ORDER BY revenue DESC;

-- -------------------------------------------------------------
-- R6. Monthly sales report
-- -------------------------------------------------------------
SELECT DATE_FORMAT(o.order_date, '%Y-%m')         AS sales_month,
       COUNT(DISTINCT o.order_id)                 AS orders,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;

-- -------------------------------------------------------------
-- R7. Top customers by total money spent
-- -------------------------------------------------------------
SELECT CONCAT(c.first_name, ' ', c.last_name)     AS customer_name,
       c.city,
       COUNT(DISTINCT o.order_id)                 AS orders,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spent
FROM customers c
JOIN orders      o  ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY total_spent DESC
LIMIT 5;

-- -------------------------------------------------------------
-- R8. Repeat customers (more than 1 order) using HAVING
-- -------------------------------------------------------------
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       COUNT(o.order_id)                      AS orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 1
ORDER BY orders DESC;

-- -------------------------------------------------------------
-- R9. Sales by state
-- -------------------------------------------------------------
SELECT c.state,
       COUNT(DISTINCT o.order_id)                 AS orders,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM customers c
JOIN orders      o  ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.state
ORDER BY revenue DESC;

-- -------------------------------------------------------------
-- R10. Revenue by payment method (completed payments only)
-- -------------------------------------------------------------
SELECT payment_method,
       COUNT(*)              AS payments,
       ROUND(SUM(amount), 2) AS total_collected
FROM payments
WHERE payment_status = 'Completed'
GROUP BY payment_method
ORDER BY total_collected DESC;

-- -------------------------------------------------------------
-- R11. Payment status summary (collected vs pending vs refunded)
-- -------------------------------------------------------------
SELECT payment_status,
       COUNT(*)              AS payments,
       ROUND(SUM(amount), 2) AS amount
FROM payments
GROUP BY payment_status;

-- -------------------------------------------------------------
-- R12. Orders bigger than the average order (subquery)
-- -------------------------------------------------------------
SELECT order_id, amount
FROM payments
WHERE payment_status <> 'Refunded'
  AND amount > (SELECT AVG(amount) FROM payments WHERE payment_status <> 'Refunded')
ORDER BY amount DESC;

-- -------------------------------------------------------------
-- R13. Customer segments with CASE
-- -------------------------------------------------------------
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_spent,
       CASE
           WHEN SUM(oi.quantity * oi.unit_price) >= 300 THEN 'VIP'
           WHEN SUM(oi.quantity * oi.unit_price) >= 100 THEN 'Regular'
           WHEN SUM(oi.quantity * oi.unit_price) >  0   THEN 'New'
           ELSE 'Inactive'
       END AS customer_segment
FROM customers c
LEFT JOIN orders o
       ON c.customer_id = o.customer_id AND o.status <> 'Cancelled'
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- -------------------------------------------------------------
-- R14. Inventory value report (stock x price) by category
-- -------------------------------------------------------------
SELECT c.category_name,
       SUM(p.stock_quantity)                     AS units_in_stock,
       ROUND(SUM(p.stock_quantity * p.price), 2) AS inventory_value
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY inventory_value DESC;

-- -------------------------------------------------------------
-- R15. (Bonus) Best-selling product in EACH category
--      Uses a CTE (WITH) and a window function (RANK)
-- -------------------------------------------------------------
WITH product_sales AS (
    SELECT c.category_name,
           p.product_name,
           SUM(oi.quantity) AS units_sold
    FROM order_items oi
    JOIN products   p ON oi.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
    JOIN orders     o ON oi.order_id   = o.order_id
    WHERE o.status <> 'Cancelled'
    GROUP BY c.category_name, p.product_name
),
ranked AS (
    SELECT category_name,
           product_name,
           units_sold,
           RANK() OVER (PARTITION BY category_name ORDER BY units_sold DESC) AS sales_rank
    FROM product_sales
)
SELECT category_name, product_name, units_sold
FROM ranked
WHERE sales_rank = 1
ORDER BY category_name;

-- -------------------------------------------------------------
-- R16. (Bonus) Running total of revenue by month
-- -------------------------------------------------------------
WITH monthly AS (
    SELECT DATE_FORMAT(o.order_date, '%Y-%m')         AS sales_month,
           ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status <> 'Cancelled'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT sales_month,
       revenue,
       SUM(revenue) OVER (ORDER BY sales_month) AS running_total
FROM monthly
ORDER BY sales_month;
