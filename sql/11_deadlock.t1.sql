-- T1 : locks Shan, then reaches for Diya
BEGIN;
UPDATE customers SET wallet_balance = wallet_balance - 100 WHERE name = 'Shan';
\echo '[T1] t=0  locked Shan'
SELECT pg_sleep(2);
\echo '[T1] t=2  now wants Diya (held by T2) -> waits'
UPDATE customers SET wallet_balance = wallet_balance + 100 WHERE name = 'Diya';
\echo '[T1] t=2  got Diya, COMMIT'
COMMIT;
