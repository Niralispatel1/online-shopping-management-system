-- =============================================================
-- File 02: Insert sample data
-- Run AFTER 01_create_tables.sql
-- =============================================================
USE online_shop;

-- -------------------------------------------------------------
-- Customers (15)
-- -------------------------------------------------------------
INSERT INTO customers (first_name, last_name, email, phone, city, state, created_at) VALUES
('Maria',   'Lopez',    'maria.lopez@email.com',    '215-555-0101', 'Philadelphia', 'PA', '2025-01-05'),
('James',   'Carter',   'james.carter@email.com',   '267-555-0102', 'Philadelphia', 'PA', '2025-01-12'),
('Aisha',   'Khan',     'aisha.khan@email.com',     '610-555-0103', 'Allentown',    'PA', '2025-02-03'),
('Daniel',  'Kim',      'daniel.kim@email.com',     '412-555-0104', 'Pittsburgh',   'PA', '2025-02-18'),
('Sofia',   'Rossi',    'sofia.rossi@email.com',    '973-555-0105', 'Newark',       'NJ', '2025-03-01'),
('Michael', 'Brown',    'michael.brown@email.com',  '856-555-0106', 'Camden',       'NJ', '2025-03-15'),
('Emily',   'Nguyen',   'emily.nguyen@email.com',   '212-555-0107', 'New York',     'NY', '2025-04-02'),
('Carlos',  'Garcia',   'carlos.garcia@email.com',  '718-555-0108', 'Brooklyn',     'NY', '2025-04-20'),
('Priya',   'Shah',     'priya.shah@email.com',     '302-555-0109', 'Wilmington',   'DE', '2025-05-07'),
('Kevin',   'Johnson',  'kevin.johnson@email.com',  '410-555-0110', 'Baltimore',    'MD', '2025-05-25'),
('Grace',   'Lee',      'grace.lee@email.com',      '215-555-0111', 'Philadelphia', 'PA', '2025-06-10'),
('Omar',    'Hassan',   'omar.hassan@email.com',    '484-555-0112', 'Chester',      'PA', '2025-07-01'),
('Hannah',  'Miller',   'hannah.miller@email.com',  '717-555-0113', 'Harrisburg',   'PA', '2025-07-19'),
('Tyler',   'Wilson',   'tyler.wilson@email.com',   '609-555-0114', 'Trenton',      'NJ', '2025-08-08'),
('Nina',    'Patel',    'nina.patel@email.com',     '201-555-0115', 'Jersey City',  'NJ', '2025-09-14');

-- -------------------------------------------------------------
-- Categories (5)
-- -------------------------------------------------------------
INSERT INTO categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Home & Kitchen'),
('Books'),
('Sports & Outdoors');

-- -------------------------------------------------------------
-- Products (20)
-- -------------------------------------------------------------
INSERT INTO products (product_name, category_id, price, stock_quantity) VALUES
('Wireless Earbuds',          1,  59.99, 120),
('Bluetooth Speaker',         1,  39.99,  80),
('USB-C Charger 65W',         1,  29.99, 200),
('27-inch Monitor',           1, 219.99,  25),
('Mechanical Keyboard',       1,  89.99,  40),
('Men''s Hoodie',             2,  34.99,  90),
('Women''s Running Jacket',   2,  64.99,  50),
('Classic T-Shirt',           2,  14.99, 300),
('Denim Jeans',               2,  49.99,  70),
('Air Fryer',                 3,  99.99,  30),
('Coffee Maker',              3,  79.99,  35),
('Non-Stick Pan Set',         3,  69.99,  45),
('LED Desk Lamp',             3,  24.99, 110),
('SQL for Beginners',         4,  27.99,  60),
('Python Crash Course',       4,  32.99,  55),
('The Data Analyst Handbook', 4,  24.99,  40),
('Yoga Mat',                  5,  25.99,  95),
('Adjustable Dumbbells',      5, 149.99,  15),
('Water Bottle 32oz',         5,  19.99, 250),
('Camping Tent 4-Person',     5, 129.99,   0);   -- out of stock on purpose

-- -------------------------------------------------------------
-- Orders (25) - spread across 2026 so we can report by month
-- -------------------------------------------------------------
INSERT INTO orders (customer_id, order_date, status) VALUES
( 1, '2026-01-04', 'Delivered'),   -- 1
( 2, '2026-01-09', 'Delivered'),   -- 2
( 3, '2026-01-15', 'Delivered'),   -- 3
( 1, '2026-01-22', 'Delivered'),   -- 4
( 4, '2026-02-02', 'Delivered'),   -- 5
( 5, '2026-02-10', 'Delivered'),   -- 6
( 6, '2026-02-14', 'Cancelled'),   -- 7
( 7, '2026-02-20', 'Delivered'),   -- 8
( 2, '2026-03-03', 'Delivered'),   -- 9
( 8, '2026-03-11', 'Delivered'),   -- 10
( 9, '2026-03-18', 'Delivered'),   -- 11
(10, '2026-03-27', 'Delivered'),   -- 12
( 1, '2026-04-05', 'Delivered'),   -- 13
(11, '2026-04-12', 'Delivered'),   -- 14
( 3, '2026-04-19', 'Delivered'),   -- 15
(12, '2026-05-02', 'Delivered'),   -- 16
( 7, '2026-05-14', 'Delivered'),   -- 17
(13, '2026-05-28', 'Cancelled'),   -- 18
( 5, '2026-06-06', 'Delivered'),   -- 19
( 2, '2026-06-17', 'Shipped'),     -- 20
(14, '2026-06-25', 'Shipped'),     -- 21
( 4, '2026-07-03', 'Shipped'),     -- 22
( 1, '2026-07-10', 'Pending'),     -- 23
( 8, '2026-07-15', 'Pending'),     -- 24
(11, '2026-07-20', 'Pending');     -- 25
-- Customer 15 (Nina Patel) has never ordered -> used in the "inactive customers" report

-- -------------------------------------------------------------
-- Order items (what was inside each order)
-- unit_price = product price at checkout
-- -------------------------------------------------------------
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
( 1,  1, 1,  59.99), ( 1,  3, 2,  29.99),
( 2,  4, 1, 219.99), ( 2,  5, 1,  89.99),
( 3,  8, 3,  14.99), ( 3,  6, 1,  34.99),
( 4, 14, 1,  27.99), ( 4, 15, 1,  32.99),
( 5, 10, 1,  99.99), ( 5, 19, 2,  19.99),
( 6,  7, 1,  64.99), ( 6, 17, 1,  25.99),
( 7, 18, 1, 149.99),
( 8,  1, 2,  59.99), ( 8, 13, 1,  24.99),
( 9, 11, 1,  79.99), ( 9, 12, 1,  69.99),
(10,  2, 1,  39.99), (10,  8, 2,  14.99), (10,  9, 1, 49.99),
(11, 14, 2,  27.99), (11, 16, 1,  24.99),
(12, 18, 1, 149.99), (12, 19, 3,  19.99),
(13,  1, 1,  59.99), (13,  2, 1,  39.99),
(14, 10, 1,  99.99), (14, 13, 2,  24.99),
(15,  8, 4,  14.99), (15,  9, 1,  49.99),
(16,  4, 1, 219.99),
(17, 15, 1,  32.99), (17, 14, 1,  27.99), (17, 16, 1, 24.99),
(18,  7, 1,  64.99),
(19, 17, 2,  25.99), (19, 19, 1,  19.99),
(20,  3, 3,  29.99), (20,  1, 1,  59.99),
(21,  5, 1,  89.99), (21, 13, 1,  24.99),
(22, 11, 1,  79.99), (22,  8, 2,  14.99),
(23,  6, 2,  34.99), (23,  1, 1,  59.99),
(24, 12, 1,  69.99),
(25, 14, 1,  27.99), (25, 19, 2,  19.99);

-- -------------------------------------------------------------
-- Payments
-- The amount is calculated from order_items so it always matches
-- the real order total (quantity x unit_price).
-- -------------------------------------------------------------
INSERT INTO payments (order_id, payment_date, amount, payment_method, payment_status)
SELECT
    o.order_id,
    o.order_date,
    SUM(oi.quantity * oi.unit_price),
    CASE MOD(o.order_id, 4)
        WHEN 0 THEN 'Credit Card'
        WHEN 1 THEN 'PayPal'
        WHEN 2 THEN 'Debit Card'
        ELSE        'Credit Card'
    END,
    CASE o.status
        WHEN 'Cancelled' THEN 'Refunded'
        WHEN 'Pending'   THEN 'Pending'
        ELSE                  'Completed'
    END
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.order_date, o.status;

-- One customer used a gift card
UPDATE payments SET payment_method = 'Gift Card' WHERE order_id = 17;

-- Quick check: row counts for every table
SELECT 'customers'   AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL SELECT 'categories',  COUNT(*) FROM categories
UNION ALL SELECT 'products',    COUNT(*) FROM products
UNION ALL SELECT 'orders',      COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payments',    COUNT(*) FROM payments;
