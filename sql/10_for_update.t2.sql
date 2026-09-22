-- T2 : blocks on the lock instead of overwriting T1
SELECT pg_sleep(1);
BEGIN;
\echo '[T2] t=1  SELECT ... FOR UPDATE  -> WAITS for T1 to finish'
SELECT stock_qty AS t2_read_after_wait FROM menu WHERE item_name = 'Cold Brew' FOR UPDATE;
\echo '[T2] t=2  woke up and read the FRESH value above'
UPDATE menu SET stock_qty = stock_qty - 1 WHERE item_name = 'Cold Brew';
COMMIT;
\echo '[T2] final stock  (3 - 2 - 1 = 0, nothing lost):'
SELECT stock_qty AS final_stock FROM menu WHERE item_name = 'Cold Brew';
