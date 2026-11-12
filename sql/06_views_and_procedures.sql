-- =============================================================
-- File 06: Views and a stored procedure (bonus)
-- Views save a query so you can reuse it like a table.
-- A stored procedure saves steps you can run with CALL.
-- =============================================================
USE online_shop;

-- -------------------------------------------------------------
-- View 1: order summary (one row per order with its total)
-- -------------------------------------------------------------
CREATE OR REPLACE VIEW v_order_summary AS
SELECT o.order_id,
       o.order_date,
       CONCAT(c.first_name, ' ', c.last_name)     AS customer_name,
       o.status,
       SUM(oi.quantity)                           AS items,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS order_total
FROM orders o
JOIN customers   c  ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
GROUP BY o.order_id, o.order_date, c.first_name, c.last_name, o.status;

-- Use it like a normal table
SELECT * FROM v_order_summary ORDER BY order_total DESC;

-- -------------------------------------------------------------
-- View 2: product sales (sold units and revenue per product)
-- -------------------------------------------------------------
CREATE OR REPLACE VIEW v_product_sales AS
SELECT p.product_id,
       p.product_name,
       c.category_name,
       p.stock_quantity,
       COALESCE(SUM(CASE WHEN o.status <> 'Cancelled' THEN oi.quantity END), 0) AS units_sold,
       COALESCE(ROUND(SUM(CASE WHEN o.status <> 'Cancelled'
                               THEN oi.quantity * oi.unit_price END), 2), 0)    AS revenue
FROM products p
JOIN categories       c  ON p.category_id = c.category_id
LEFT JOIN order_items oi ON p.product_id  = oi.product_id
LEFT JOIN orders      o  ON oi.order_id   = o.order_id
GROUP BY p.product_id, p.product_name, c.category_name, p.stock_quantity;

SELECT * FROM v_product_sales ORDER BY units_sold DESC;

-- -------------------------------------------------------------
-- Stored procedure: get the full order history for one customer
-- Usage: CALL get_customer_orders(1);
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS get_customer_orders;

DELIMITER //
CREATE PROCEDURE get_customer_orders(IN p_customer_id INT)
BEGIN
    SELECT order_id, order_date, status, items, order_total
    FROM v_order_summary
    WHERE order_id IN (SELECT order_id FROM orders WHERE customer_id = p_customer_id)
    ORDER BY order_date;
END //
DELIMITER ;

CALL get_customer_orders(1);
