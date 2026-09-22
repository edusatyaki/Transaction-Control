-- =====================================================================
-- DEMO 3  |  SAVEPOINT : rolling back part of a transaction
-- Shan orders an Espresso, then changes his mind about the cake,
-- but keeps the Espresso. One transaction, partial undo.
--   psql -d transaction_cafe -f sql/03_savepoint.sql
-- =====================================================================

\echo '--- BEFORE -------------------------------------------------------'
SELECT name, wallet_balance FROM customers WHERE name = 'Shan';

BEGIN;

    -- Espresso 120 : this one he keeps
    UPDATE customers SET wallet_balance = wallet_balance - 120 WHERE name = 'Shan';

    SAVEPOINT after_espresso;                   -- <== bookmark

    -- Blueberry Cake 320 : added, then regretted
    UPDATE customers SET wallet_balance = wallet_balance - 320 WHERE name = 'Shan';
    UPDATE menu SET stock_qty = stock_qty - 1 WHERE item_name = 'Blueberry Cake';

    \echo '--- after adding the cake (uncommitted) ---------------------------'
    SELECT name, wallet_balance FROM customers WHERE name = 'Shan';

    ROLLBACK TO SAVEPOINT after_espresso;       -- <== undo ONLY the cake

    \echo '--- after ROLLBACK TO SAVEPOINT ----------------------------------'
    SELECT name, wallet_balance FROM customers WHERE name = 'Shan';

COMMIT;                                         -- the Espresso still commits

\echo '--- AFTER COMMIT : 5000 - 120 = 4880, cake stock untouched -------'
SELECT name, wallet_balance FROM customers WHERE name = 'Shan';
SELECT item_name, stock_qty FROM menu WHERE item_name = 'Blueberry Cake';
