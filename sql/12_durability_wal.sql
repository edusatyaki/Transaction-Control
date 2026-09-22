-- =====================================================================
-- DEMO 12 |  DURABILITY : why a committed order survives a power cut
-- COMMIT does not just change the table - it forces the change into the
-- Write-Ahead Log on disk first. Watch the WAL position move.
--   psql -d transaction_cafe -f sql/12_durability_wal.sql
-- =====================================================================
\echo '--- the safety switches --------------------------------------------'
SHOW fsync;                 -- on  = flush WAL to physical disk at COMMIT
SHOW synchronous_commit;    -- on  = do not report COMMIT until that flush is done
SHOW wal_level;

\echo '--- WAL position BEFORE the order ----------------------------------'
SELECT pg_current_wal_lsn() AS wal_before;

BEGIN;
  UPDATE customers SET wallet_balance = wallet_balance - 250 WHERE name = 'Shan';
  INSERT INTO cafe_ledger (description, amount) VALUES ('Cold Brew x1 - Shan', 250);
COMMIT;

\echo '--- WAL position AFTER the commit (it moved: the order is on disk) --'
SELECT pg_current_wal_lsn() AS wal_after;
SELECT pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), '0/0')) AS wal_written_total;
