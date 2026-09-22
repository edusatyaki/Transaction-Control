-- T2 : asks for the LOWEST isolation level and tries to peek
SELECT pg_sleep(1);
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
\echo '[T2] t=1  asked for READ UNCOMMITTED. PostgreSQL reports:'
SHOW transaction_isolation;
\echo '[T2] t=1  reading Diya while T1 holds an uncommitted 3000:'
SELECT name, wallet_balance AS what_t2_sees FROM customers WHERE name = 'Diya';
COMMIT;
SELECT pg_sleep(3);
\echo '[T2] t=4  after T1 rolled back:'
SELECT name, wallet_balance AS what_t2_sees FROM customers WHERE name = 'Diya';
