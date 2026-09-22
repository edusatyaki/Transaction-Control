-- T1 : same accountant, this time at REPEATABLE READ (snapshot frozen at BEGIN)
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
\echo '[T1] t=0  first read of Diya (REPEATABLE READ):'
SELECT name, wallet_balance AS read_1 FROM customers WHERE name = 'Diya';
SELECT pg_sleep(3);
\echo '[T1] t=3  second read - snapshot has not moved:'
SELECT name, wallet_balance AS read_2 FROM customers WHERE name = 'Diya';
COMMIT;
\echo '[T1] t=3  after COMMIT, outside the snapshot, the truth:'
SELECT name, wallet_balance AS after_commit FROM customers WHERE name = 'Diya';
