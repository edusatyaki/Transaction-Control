-- T1 : same count, this time at REPEATABLE READ
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
\echo '[T1] t=0  first count (REPEATABLE READ):'
SELECT count(*) AS big_orders_read_1 FROM orders WHERE amount > 1000;
SELECT pg_sleep(3);
\echo '[T1] t=3  second count - no phantom row appears:'
SELECT count(*) AS big_orders_read_2 FROM orders WHERE amount > 1000;
COMMIT;
\echo '[T1] t=3  outside the transaction the new row IS there:'
SELECT count(*) AS after_commit FROM orders WHERE amount > 1000;
