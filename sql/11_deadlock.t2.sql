-- T2 : locks Diya, then reaches for Shan  -> opposite order = deadlock
BEGIN;
UPDATE customers SET wallet_balance = wallet_balance - 50 WHERE name = 'Diya';
\echo '[T2] t=0  locked Diya'
SELECT pg_sleep(2);
\echo '[T2] t=2  now wants Shan (held by T1) -> waits'
UPDATE customers SET wallet_balance = wallet_balance + 50 WHERE name = 'Shan';
\echo '[T2] t=2  got Shan, COMMIT'
COMMIT;
