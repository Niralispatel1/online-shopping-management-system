-- =============================================================
-- File 04: Connecting tables with JOIN
-- Skills: INNER JOIN, LEFT JOIN, multi-table joins, aliases
-- =============================================================
USE online_shop;

-- J1. Each product with its category name (INNER JOIN)
SELECT p.product_name, c.category_name, p.price
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
ORDER BY c.category_name, p.product_name;

-- J2. Every order with the customer's full name
SELECT o.order_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       o.order_date,
       o.status
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;

-- J3. Full receipt for one order: customer + products + line totals
SELECT o.order_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       p.product_name,
       oi.quantity,
       oi.unit_price,
       oi.quantity * oi.unit_price AS line_total
FROM orders o
JOIN customers   c  ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
JOIN products    p  ON oi.product_id = p.product_id
WHERE o.order_id = 10;

-- J4. Each order with its total, payment method, and payment status
SELECT o.order_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       o.status        AS order_status,
       pay.amount      AS order_total,
       pay.payment_method,
       pay.payment_status
FROM orders o
JOIN customers c   ON o.customer_id = c.customer_id
JOIN payments  pay ON o.order_id    = pay.order_id
ORDER BY o.order_id;

-- J5. ALL customers, even ones who never ordered (LEFT JOIN)
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       COUNT(o.order_id) AS number_of_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY number_of_orders DESC;

-- J6. Customers who have NEVER placed an order
SELECT c.customer_id, c.first_name, c.last_name, c.email
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- J7. Products that have NEVER been sold
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

-- J8. What did each customer buy? (one row per customer + product)
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       p.product_name,
       SUM(oi.quantity) AS total_quantity
FROM customers c
JOIN orders      o  ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
JOIN products    p  ON oi.product_id = p.product_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.first_name, c.last_name, p.product_name
ORDER BY customer_name, p.product_name;
