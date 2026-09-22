# Transaction Cafe — DBMS Transactions, practical + presenter deck

A companion to the *Transaction Cafe* slides. Twelve runnable PostgreSQL demos
covering ACID, the three read anomalies, isolation levels, lost updates,
deadlocks and WAL durability — plus a presenter-mode visualisation whose every
result was captured from an actual run of these scripts.

## 1. Set up the database

```bash
export PATH=/opt/homebrew/opt/postgresql@15/bin:$PATH   # psql is not on PATH by default
createdb -h 127.0.0.1 transaction_cafe
psql -h 127.0.0.1 -d transaction_cafe -f sql/00_setup.sql
```

Four tables — `customers`, `menu`, `orders`, `cafe_ledger` — two CHECK
constraints, and seed data: both customers at ₹5000, only 3 Cold Brews on the
counter, and three existing orders above ₹1000 for the phantom-read demo.

## 2. Single-session demos

```bash
psql -h 127.0.0.1 -d transaction_cafe -f sql/01_atomicity_commit.sql
psql -h 127.0.0.1 -d transaction_cafe -f sql/02_atomicity_rollback.sql
psql -h 127.0.0.1 -d transaction_cafe -f sql/03_savepoint.sql
psql -h 127.0.0.1 -d transaction_cafe -f sql/12_durability_wal.sql
```

## 3. Two-session demos

Each of these ships as a `.t1.sql` / `.t2.sql` pair. `run_demo.sh` resets the
database, launches both sessions at once, and prints the two transcripts
side by side. The sessions pace themselves with `pg_sleep()`, so the
interleaving is identical on every run.

```bash
./run_demo.sh 04_dirty_read          # PostgreSQL refuses to give you one
./run_demo.sh 05_non_repeatable_read # READ COMMITTED: 5000 then 3000
./run_demo.sh 06_repeatable_read     # same script, stable snapshot
./run_demo.sh 07_phantom_read        # READ COMMITTED: 3 rows then 4
./run_demo.sh 08_phantom_prevented   # REPEATABLE READ: still 3
./run_demo.sh 09_lost_update         # SQLSTATE 40001
./run_demo.sh 10_for_update          # SELECT ... FOR UPDATE, nothing lost
./run_demo.sh 11_deadlock            # SQLSTATE 40P01
```

To run a pair by hand instead, open two terminals and type the statements in
`t=` order — the timestamps in each file say when each statement belongs.

## 4. The presenter deck

```bash
python3 -m http.server 8103 --directory transaction-cafe
```

then open <http://localhost:8103> (also registered in `.claude/launch.json` as
`transaction-cafe`).

| Key | Action |
|-----|--------|
| `→` / `Space` / click | next step |
| `←` | previous step |
| `↓` / `↑` | next / previous slide |
| `S` | speaker notes drawer |
| `O` | run of show (jump to any slide) |
| `F` | full screen |
| `R` | restart the current slide |
| `Home` / `End` | first / last slide |

16 slides, 73 steps. Each demo slide replays the two terminals statement by
statement, with a live state strip underneath showing wallet balances, stock
counts and row counts as they change — dashed gold for uncommitted, green for
committed.

## Two places PostgreSQL differs from the textbook table

Worth calling out in class, because the slides quote the ANSI table:

1. **READ UNCOMMITTED does not give you dirty reads.** PostgreSQL accepts the
   level and even reports it back, but implements it as READ COMMITTED. Demo 4
   asks for it explicitly and still reads the committed ₹5000.00.
2. **REPEATABLE READ already prevents phantom reads.** PostgreSQL's REPEATABLE
   READ is snapshot isolation, and a frozen snapshot cannot show rows created
   after it. Demo 8 counts 3 rows twice where the standard permits 3 then 4.

The ANSI levels define the *minimum* an engine must prevent; an engine may
prevent more.

## Verified against

PostgreSQL 15.15 (Homebrew) on aarch64-apple-darwin24.6.0, port 5432.
