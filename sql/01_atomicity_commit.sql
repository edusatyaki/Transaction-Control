-- =====================================================================
-- DEMO 1  |  ATOMICITY + DURABILITY : the happy path (COMMIT)
-- One coffee order = 4 writes that must all land together.
--   psql -d transaction_cafe -f sql/01_atomicity_commit.sql
-- =====================================================================

\echo '--- BEFORE -------------------------------------------------------'
SELECT name, wallet_balance FROM customers WHERE name = 'Diya';
SELECT item_name, stock_qty FROM menu WHERE item_name = 'Cappuccino';

BEGIN;                                              -- BEGIN TRANSACTION

    -- 1. debit the wallet
    UPDATE customers SET wallet_balance = wallet_balance - 180
    WHERE name = 'Diya';

    -- 2. place the order
    INSERT INTO orders (cust_id, item_id, qty, amount)
    SELECT c.cust_id, m.item_id, 1, m.price
    FROM customers c, menu m
    WHERE c.name = 'Diya' AND m.item_name = 'Cappuccino';

    -- 3. take one cup off the counter
    UPDATE menu SET stock_qty = stock_qty - 1
    WHERE item_name = 'Cappuccino';

    -- 4. write the ledger entry
    INSERT INTO cafe_ledger (order_id, description, amount)
    VALUES (currval('orders_order_id_seq'), 'Cappuccino x1 - Diya', 180);

    \echo '--- INSIDE the transaction (uncommitted) --------------------------'
    SELECT name, wallet_balance FROM customers WHERE name = 'Diya';

COMMIT;                                             -- all four are now permanent

\echo '--- AFTER COMMIT -------------------------------------------------'
SELECT name, wallet_balance FROM customers WHERE name = 'Diya';
SELECT item_name, stock_qty FROM menu WHERE item_name = 'Cappuccino';
SELECT entry_id, description, amount FROM cafe_ledger ORDER BY entry_id DESC LIMIT 1;
