-- T1 : manager counting today's big orders, at READ COMMITTED
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
\echo '[T1] t=0  SELECT count(*) FROM orders WHERE amount > 1000'
SELECT count(*) AS big_orders_read_1 FROM orders WHERE amount > 1000;
SELECT pg_sleep(3);
\echo '[T1] t=3  SAME query again:'
SELECT count(*) AS big_orders_read_2 FROM orders WHERE amount > 1000;
COMMIT;
