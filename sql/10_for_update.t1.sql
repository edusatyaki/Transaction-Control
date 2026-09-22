-- T1 : the correct pattern - lock the row before reading it
BEGIN;
\echo '[T1] t=0  SELECT ... FOR UPDATE  (row is now locked by T1)'
SELECT stock_qty AS t1_locked_read FROM menu WHERE item_name = 'Cold Brew' FOR UPDATE;
SELECT pg_sleep(2);
UPDATE menu SET stock_qty = stock_qty - 2 WHERE item_name = 'Cold Brew';
\echo '[T1] t=2  sold 2, COMMIT'
COMMIT;
