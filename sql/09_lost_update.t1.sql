-- T1 : sells 2 Cold Brews.  Read-then-write, at REPEATABLE READ.
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
\echo '[T1] t=0  reads stock:'
SELECT stock_qty AS t1_sees FROM menu WHERE item_name = 'Cold Brew';
SELECT pg_sleep(2);
\echo '[T1] t=2  writes stock = 3 - 2 = 1 and commits'
UPDATE menu SET stock_qty = 1 WHERE item_name = 'Cold Brew';
COMMIT;
