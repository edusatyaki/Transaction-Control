-- T2 : a new big order walks in halfway through T1
SELECT pg_sleep(1);
BEGIN;
INSERT INTO orders (cust_id, item_id, qty, amount, status)
VALUES (2, 4, 4, 1200.00, 'PLACED');
COMMIT;
\echo '[T2] t=1  inserted a NEW order of 1200 and COMMITTED'
