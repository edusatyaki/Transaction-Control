#!/usr/bin/env bash
# Runs a two-session concurrency demo: sql/<name>.t1.sql and sql/<name>.t2.sql
# are executed simultaneously against transaction_cafe. Each session paces
# itself with pg_sleep() so the interleaving is identical on every run.
set -u
export PATH=/opt/homebrew/opt/postgresql@15/bin:$PATH
PSQL="psql -h 127.0.0.1 -p 5432 -d transaction_cafe -X -q"
NAME="$1"
DIR="$(cd "$(dirname "$0")" && pwd)"

$PSQL -f "$DIR/sql/00_setup.sql" >/dev/null 2>&1   # clean slate: both wallets 5000

$PSQL -f "$DIR/sql/${NAME}.t1.sql" > "/tmp/${NAME}.t1.out" 2>&1 &
P1=$!
$PSQL -f "$DIR/sql/${NAME}.t2.sql" > "/tmp/${NAME}.t2.out" 2>&1 &
P2=$!
wait $P1 $P2

echo "================= SESSION 1  (T1) ================="
cat "/tmp/${NAME}.t1.out"
echo "================= SESSION 2  (T2) ================="
cat "/tmp/${NAME}.t2.out"
