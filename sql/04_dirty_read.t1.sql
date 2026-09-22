-- T1 : the barista who changes a balance and then cancels
\echo '[T1] t=0  BEGIN (READ COMMITTED)'
BEGIN;
UPDATE customers SET wallet_balance = 3000 WHERE name = 'Diya';
\echo '[T1] t=0  updated Diya 5000 -> 3000   (NOT committed yet)'
SELECT pg_sleep(3);
\echo '[T1] t=3  ROLLBACK  -- the change never really happened'
ROLLBACK;
SELECT name, wallet_balance AS after_rollback FROM customers WHERE name = 'Diya';
