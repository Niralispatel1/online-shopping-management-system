-- =============================================================
-- Online Shopping Management System
-- File 01: Create the database and tables
-- Database: MySQL 8.0+ (also works on MariaDB 10.5+)
-- =============================================================

-- Start fresh every time you run this file
DROP DATABASE IF EXISTS online_shop;
CREATE DATABASE online_shop;
USE online_shop;

-- -------------------------------------------------------------
-- 1. CUSTOMERS: people who shop in the store
-- -------------------------------------------------------------
CREATE TABLE customers (
    customer_id   INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    phone         VARCHAR(20),
    city          VARCHAR(50),
    state         CHAR(2),
    created_at    DATE NOT NULL
);

-- -------------------------------------------------------------
-- 2. CATEGORIES: groups of products (Electronics, Books, ...)
-- -------------------------------------------------------------
CREATE TABLE categories (
    category_id    INT AUTO_INCREMENT PRIMARY KEY,
    category_name  VARCHAR(50) NOT NULL UNIQUE
);

-- -------------------------------------------------------------
-- 3. PRODUCTS: items for sale
-- -------------------------------------------------------------
CREATE TABLE products (
    product_id      INT AUTO_INCREMENT PRIMARY KEY,
    product_name    VARCHAR(100)  NOT NULL,
    category_id     INT           NOT NULL,
    price           DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity  INT           NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- -------------------------------------------------------------
-- 4. ORDERS: one row per checkout
-- -------------------------------------------------------------
CREATE TABLE orders (
    order_id      INT AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT  NOT NULL,
    order_date    DATE NOT NULL,
    status        VARCHAR(20) NOT NULL DEFAULT 'Pending'
                  CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- -------------------------------------------------------------
-- 5. ORDER_ITEMS: which products are inside each order
--    (an order can have many products -> "many-to-many" bridge)
-- -------------------------------------------------------------
CREATE TABLE order_items (
    order_item_id  INT AUTO_INCREMENT PRIMARY KEY,
    order_id       INT           NOT NULL,
    product_id     INT           NOT NULL,
    quantity       INT           NOT NULL CHECK (quantity > 0),
    unit_price     DECIMAL(10,2) NOT NULL,   -- price at the time of purchase
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- -------------------------------------------------------------
-- 6. PAYMENTS: how each order was paid
-- -------------------------------------------------------------
CREATE TABLE payments (
    payment_id      INT AUTO_INCREMENT PRIMARY KEY,
    order_id        INT           NOT NULL UNIQUE,  -- one payment per order
    payment_date    DATE          NOT NULL,
    amount          DECIMAL(10,2) NOT NULL,
    payment_method  VARCHAR(20)   NOT NULL
                    CHECK (payment_method IN ('Credit Card', 'Debit Card', 'PayPal', 'Gift Card')),
    payment_status  VARCHAR(20)   NOT NULL
                    CHECK (payment_status IN ('Completed', 'Pending', 'Refunded')),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Indexes make searches on these columns faster
CREATE INDEX idx_orders_customer   ON orders(customer_id);
CREATE INDEX idx_orders_date       ON orders(order_date);
CREATE INDEX idx_items_product     ON order_items(product_id);

SHOW TABLES;
