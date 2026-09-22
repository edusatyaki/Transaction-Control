-- T2 : ALSO sells 2 Cold Brews, from the same starting number.
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
\echo '[T2] t=0  reads stock (same value T1 saw):'
SELECT stock_qty AS t2_sees FROM menu WHERE item_name = 'Cold Brew';
SELECT pg_sleep(3);
\echo '[T2] t=3  tries to write stock = 3 - 2 = 1 as well:'
UPDATE menu SET stock_qty = 1 WHERE item_name = 'Cold Brew';
COMMIT;
\echo '[T2] t=3  final truth on the counter:'
SELECT stock_qty AS final_stock FROM menu WHERE item_name = 'Cold Brew';
