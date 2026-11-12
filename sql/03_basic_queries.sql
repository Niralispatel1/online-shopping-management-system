-- =============================================================
-- File 03: Basic queries + UPDATE and DELETE practice
-- Skills: SELECT, WHERE, ORDER BY, LIMIT, LIKE, BETWEEN,
--         UPDATE, DELETE, transactions
-- =============================================================
USE online_shop;

-- Q1. Show all customers
SELECT * FROM customers;

-- Q2. Show only names and emails, sorted by last name
SELECT first_name, last_name, email
FROM customers
ORDER BY last_name;

-- Q3. Customers who live in Pennsylvania
SELECT first_name, last_name, city
FROM customers
WHERE state = 'PA';

-- Q4. Products that cost more than $50, most expensive first
SELECT product_name, price
FROM products
WHERE price > 50
ORDER BY price DESC;

-- Q5. Products priced between $20 and $40
SELECT product_name, price
FROM products
WHERE price BETWEEN 20 AND 40;

-- Q6. Products with "Book" or "Course" in the name (pattern search)
SELECT product_name
FROM products
WHERE product_name LIKE '%Course%' OR product_name LIKE '%Book%';

-- Q7. The 5 cheapest products
SELECT product_name, price
FROM products
ORDER BY price ASC
LIMIT 5;

-- Q8. Products that are low on stock (under 30) - restock alert
SELECT product_name, stock_quantity
FROM products
WHERE stock_quantity < 30
ORDER BY stock_quantity;

-- Q9. Orders placed in the first quarter of 2026
SELECT order_id, customer_id, order_date, status
FROM orders
WHERE order_date BETWEEN '2026-01-01' AND '2026-03-31';

-- Q10. How many orders are in each status?
SELECT status, COUNT(*) AS total_orders
FROM orders
GROUP BY status;

-- =============================================================
-- UPDATE practice
-- =============================================================

-- U1. A customer changed her phone number
UPDATE customers
SET phone = '215-555-9999'
WHERE customer_id = 1;

-- U2. Price increase: Coffee Maker goes up to $84.99
UPDATE products
SET price = 84.99
WHERE product_name = 'Coffee Maker';

-- U3. 10% off every Book
UPDATE products
SET price = ROUND(price * 0.90, 2)
WHERE category_id = (SELECT category_id FROM categories WHERE category_name = 'Books');

-- U4. Restock the Camping Tent (it was out of stock)
UPDATE products
SET stock_quantity = stock_quantity + 20
WHERE product_name = 'Camping Tent 4-Person';

-- U5. Order 20 arrived -> mark it Delivered
UPDATE orders
SET status = 'Delivered'
WHERE order_id = 20;

-- Check the changes
SELECT product_name, price, stock_quantity
FROM products
WHERE product_name IN ('Coffee Maker', 'Camping Tent 4-Person')
   OR category_id = 4;

-- =============================================================
-- DELETE practice (safely, inside a transaction)
-- A transaction lets you undo changes with ROLLBACK.
-- =============================================================

START TRANSACTION;

-- Add a test customer, then delete them
INSERT INTO customers (first_name, last_name, email, city, state, created_at)
VALUES ('Test', 'User', 'test.user@email.com', 'Philadelphia', 'PA', CURDATE());

DELETE FROM customers
WHERE email = 'test.user@email.com';

-- Make sure the test customer is gone
SELECT COUNT(*) AS test_users_left
FROM customers
WHERE email = 'test.user@email.com';

COMMIT;

-- Note: you CANNOT delete a customer who has orders.
-- The FOREIGN KEY protects the data. Try it and you will get an error:
-- DELETE FROM customers WHERE customer_id = 1;
