-- T2 : Diya actually spends money in the middle of T1
SELECT pg_sleep(1);
BEGIN;
UPDATE customers SET wallet_balance = 3000 WHERE name = 'Diya';
COMMIT;
\echo '[T2] t=1  updated Diya 5000 -> 3000 and COMMITTED'
