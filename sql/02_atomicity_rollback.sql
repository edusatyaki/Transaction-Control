-- =====================================================================
-- DEMO 2  |  ATOMICITY + CONSISTENCY : the failure path (ROLLBACK)
-- Shan orders 5 Cold Brews. Only 3 are on the counter.
-- The wallet is debited FIRST, then the stock update breaks a CHECK.
-- All-or-nothing: the debit must be undone too.
--   psql -d transaction_cafe -f sql/02_atomicity_rollback.sql
-- =====================================================================

\echo '--- BEFORE -------------------------------------------------------'
SELECT name, wallet_balance FROM customers WHERE name = 'Shan';
SELECT item_name, stock_qty FROM menu WHERE item_name = 'Cold Brew';

BEGIN;

    -- 1. debit 5 x 250 = 1250 (this SUCCEEDS)
    UPDATE customers SET wallet_balance = wallet_balance - 1250
    WHERE name = 'Shan';

    \echo '--- money is gone (inside the transaction) ------------------------'
    SELECT name, wallet_balance FROM customers WHERE name = 'Shan';

    -- 2. try to take 5 cups when only 3 exist  -> CHECK stock_qty >= 0 FAILS
    UPDATE menu SET stock_qty = stock_qty - 5
    WHERE item_name = 'Cold Brew';

    -- 3. anything after the error is refused: transaction is already aborted
    INSERT INTO cafe_ledger (description, amount)
    VALUES ('Cold Brew x5 - Shan', 1250);

ROLLBACK;                                   -- undo EVERYTHING, including step 1

\echo '--- AFTER ROLLBACK : nothing happened at all ----------------------'
SELECT name, wallet_balance FROM customers WHERE name = 'Shan';
SELECT item_name, stock_qty FROM menu WHERE item_name = 'Cold Brew';
SELECT count(*) AS ledger_rows FROM cafe_ledger;
