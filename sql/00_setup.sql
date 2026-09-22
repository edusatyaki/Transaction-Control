-- =====================================================================
-- Transaction Cafe  |  00_setup.sql
-- Schema + seed data for the DBMS Transactions practical (PostgreSQL)
--   Run:  psql -d transaction_cafe -f sql/00_setup.sql
-- =====================================================================

DROP TABLE IF EXISTS cafe_ledger, orders, menu, customers CASCADE;

-- Customers walk in with a wallet -------------------------------------
CREATE TABLE customers (
    cust_id        SERIAL PRIMARY KEY,
    name           TEXT    NOT NULL,
    wallet_balance NUMERIC(10,2) NOT NULL
        CONSTRAINT wallet_never_negative CHECK (wallet_balance >= 0)
);

-- The counter: every item has a finite stock --------------------------
CREATE TABLE menu (
    item_id   SERIAL PRIMARY KEY,
    item_name TEXT    NOT NULL,
    price     NUMERIC(10,2) NOT NULL,
    stock_qty INT     NOT NULL
        CONSTRAINT stock_never_negative CHECK (stock_qty >= 0)
);

-- Orders placed at the counter ----------------------------------------
CREATE TABLE orders (
    order_id  SERIAL PRIMARY KEY,
    cust_id   INT  REFERENCES customers(cust_id),
    item_id   INT  REFERENCES menu(item_id),
    qty       INT  NOT NULL CHECK (qty > 0),
    amount    NUMERIC(10,2) NOT NULL,
    status    TEXT NOT NULL DEFAULT 'PLACED',
    placed_at TIMESTAMP NOT NULL DEFAULT now()
);

-- The durable record: what survives a crash ---------------------------
CREATE TABLE cafe_ledger (
    entry_id    SERIAL PRIMARY KEY,
    order_id    INT REFERENCES orders(order_id),
    description TEXT NOT NULL,
    amount      NUMERIC(10,2) NOT NULL,
    entry_time  TIMESTAMP NOT NULL DEFAULT now()
);

-- Seed ----------------------------------------------------------------
INSERT INTO customers (name, wallet_balance) VALUES
    ('Shan', 5000.00),
    ('Diya', 5000.00);

INSERT INTO menu (item_name, price, stock_qty) VALUES
    ('Cold Brew',      250.00,  3),
    ('Cappuccino',     180.00, 10),
    ('Espresso',       120.00, 15),
    ('Blueberry Cake', 320.00,  6);

-- Three existing high-value orders (> 1000) for the phantom-read demo --
INSERT INTO orders (cust_id, item_id, qty, amount, status) VALUES
    (1, 4, 4, 1280.00, 'SERVED'),
    (2, 2, 7, 1260.00, 'SERVED'),
    (1, 3, 10, 1200.00, 'SERVED');

-- A helper every demo calls to show the current state ------------------
CREATE OR REPLACE VIEW cafe_state AS
SELECT c.name,
       c.wallet_balance,
       (SELECT stock_qty FROM menu WHERE item_name = 'Cold Brew')  AS cold_brew_stock,
       (SELECT stock_qty FROM menu WHERE item_name = 'Cappuccino') AS cappuccino_stock,
       (SELECT count(*)  FROM orders WHERE amount > 1000)          AS big_orders
FROM customers c
ORDER BY c.cust_id;

SELECT * FROM cafe_state;
