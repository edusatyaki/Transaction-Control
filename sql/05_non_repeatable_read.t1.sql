-- T1 : the accountant, running at READ COMMITTED (PostgreSQL default)
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
\echo '[T1] t=0  first read of Diya:'
SELECT name, wallet_balance AS read_1 FROM customers WHERE name = 'Diya';
SELECT pg_sleep(3);
\echo '[T1] t=3  SAME query, SAME transaction, second read:'
SELECT name, wallet_balance AS read_2 FROM customers WHERE name = 'Diya';
COMMIT;
