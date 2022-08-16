The triggered crash count of these fuzzers on different DBMS (12 hours, 5 times)

|                          | DBMS         | SQLite                        | DuckDB                                    | MariaDB                                      | PostgreSQL                    |
| ------------------------ | ------------ | ----------------------------- | ----------------------------------------- | -------------------------------------------- | ----------------------------- |
| **Exp Version**          |              | v1.0                          | v0.0                                      | v1.1                                         | v1.1                          |
| **Crash Count**          | Griffin      | 0,0,0,0,1,1,1,1,1,1,2,2,2,2,5 | 7,8,8,8,9,9,9,9,9,10,10,10,10,10,10,10,11 | 10,10,10,11,12,12,15,15,15,15,18,18,19,20,21 | 1,1,1,1,1,1,2,2,2,2,2,2,2,2,3 |
|                          | Squirrel     | 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 | N/A                                       | 1, 3, 3, 4, 4, 4, 4, 5, 5, 6, 6, 6, 7, 8, 8  | 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 |
|                          | SQLsmith     | 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 | 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0             | N/A                                          | 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 |
|                          | SQLancer     | 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 | 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0             | 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  | 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 |
| **p-value: Griffin**     | vs. Squirrel | 0.00007385                    | N/A                                       | 0.000003121                                  | 0.0000004608                  |
|                          | vs. SQLsmith | 0.00007385                    | 0.0000003315                              | N/A                                          | 0.0000004608                  |
|                          | vs. SQLancer | 0.00007385                    | 0.0000003315                              | 0.0000006517                                 | 0.0000004608                  |
| **effect size: Griffin** | vs. Squirrel | 0.8666667                     | N/A                                       | 1                                            | 1                             |
|                          | vs. SQLsmith | 0.8666667                     | 1                                         | N/A                                          | 1                             |
|                          | vs. SQLancer | 0.8666667                     | 1                                         | 1                                            | 1                             |

### DuckDB
```bash
mkdir -p /root/crashes; 
cp /root/out/*/crashes/* /root/crashes; 
mkdir -p /root/backtrace; 
for x in /root/crashes/*; do bname=$(basename $x); SQLSIM_TIMEOUT_MS=1000 /root/autodriver_afl_asan_debug < "$x" 2> /root/backtrace/"$bname"; done;

# uniq backtrace
for x in /root/backtrace/*; do grep -oP --binary-files=text "/root/.*(\.c|\.cc|\.cpp)(:\d+|'|\")" $x | head -1; done;
(for x in /root/backtrace/*; do grep -oP --binary-files=text "/root/.*(\.c|\.cc|\.cpp)(:\d+|\")" $x | head -1; done) | sort | uniq | wc -l
```

### SQLite
```bash
/root/AFLplusplus/afl-clang-fast++ -g /root/target.cc /root/bin_original/usr/local/lib/libsqlite3.a -o /root/sqlite_driver_fast -lpthread -ldl
mkdir -p /root/crashes
cp /dev/shm/xxx/*/crashes/* /root/crashes
mkdir -p /root/backtrace
for x in /root/crashes/*; do echo "$x"; echo -e "r < $x \nbt" | gdb /root/sqlite_driver_fast > /root/backtrace/$(basename "$x"); done

# uniq assertion
cd /root/backtrace
grep "assertion=0x[a-z0-9]*" ./ -roh | sort | uniq | wc -l

# uniq signal
cd /root/backtrace
grep "SIG" ./ -rh | sort | uniq
```

### MariaDB
```bash
# extract backtrace from tail of log files
mkdir -p /root/backtrace
for x in /root/*log*
do
    cat "$x" | tail -100 > /root/backtrace/$(basename $x)
done

# unique backtrace
for x in /root/*log*
do
    grep -P --binary-files=text "(\.c|\.cc):(\d+).*\[.*\]" $x | grep -vP --binary-files=text "signal_handler|stacktrace" | head -1
done

# crashes
mkdir -p /root/crashes
cp /root/squirrel/MariaDB/docker/output/crashes/* /root/crashes
cp /dev/shm/xxx/default/crashes/*                 /root/crashes

# global uniq script
for y in ./*; do echo -n "$y"; (for x in ./"$y"/*log*; do grep -P --binary-files=text "(\.c|\.cc):(\d+).*\[.*\]" $x | grep -vP --binary-files=text "signal_handler|stacktrace" | head -1; done) | sort | uniq | wc -l;  done
```

### PostgreSQL
```bash
# extract unnormal server terminated from log
mkdir -p /root/unnormal_terminate
for x in /root/*log*
do
    bname=$(basename "$x")
    grep "server process (PID .*) was terminated by signal " "$x" -B 100 -A 10 > /root/unnormal_terminate/"$bname"
done

grep "AddressSanitizer: .* on address" /root/unnormal_terminate/* -ho | sort | uniq  # uniq address sanitizer info
grep "was terminated by signal .*"     /root/unnormal_terminate/* -ho | sort | uniq  # uniq signal (note that all address sanitizer info are in signal 6)
```

### statistical test

#### code

```R
sqlite_griffin  = c(0,0,0,0,1,1,1,1,1,1,2,2,2,2,5)
sqlite_squirrel = c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

duckdb_griffin = c(7,8,8,8,9,9,9,9,9,10,10,10,10,10,10,10,11)
duckdb_sqlsmith = c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

mariadb_griffin = c(10,10,10,11,12,12,15,15,15,15,18,18,19,20,21)
mariadb_squirrel = c(1, 3, 3, 4, 4, 4, 4, 5, 5, 6, 6, 6, 7, 8, 8)
mariadb_sqlancer = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

postgres_griffin =  c(1,1,1,1,1,1,2,2,2,2,2,2,2,2,3)
postgres_squirrel = c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

wilcox.test(sqlite_griffin, sqlite_squirrel)
wilcox.test(duckdb_griffin, duckdb_sqlsmith)
wilcox.test(mariadb_griffin, mariadb_squirrel)
wilcox.test(mariadb_griffin, mariadb_sqlancer)
wilcox.test(postgres_griffin, postgres_squirrel)

library('effsize')
library(crayon)

cat("[EFFECT SIZE]: sqlite_griffin vs sqlite_squirrel")
VD.A(sqlite_griffin, sqlite_squirrel)

cat("[EFFECT SIZE]: duckdb_griffin vs duckdb_sqlsmith")
VD.A(duckdb_griffin, duckdb_sqlsmith)

cat("[EFFECT SIZE]: mariadb_griffin vs mariadb_squirrel")
VD.A(mariadb_griffin, mariadb_squirrel)

cat("[EFFECT SIZE]: mariadb_griffin vs mariadb_sqlancer")
VD.A(mariadb_griffin, mariadb_sqlancer)

cat("[EFFECT SIZE]: postgres_griffin vs postgres_squirrel")
VD.A(postgres_griffin, postgres_squirrel)
```

#### result
```
	Wilcoxon rank sum test with continuity correction

data:  sqlite_griffin and sqlite_squirrel
W = 195, p-value = 7.385e-05
alternative hypothesis: true location shift is not equal to 0

Warning message:
In wilcox.test.default(sqlite_griffin, sqlite_squirrel) :
  cannot compute exact p-value with ties

	Wilcoxon rank sum test with continuity correction

data:  duckdb_griffin and duckdb_sqlsmith
W = 255, p-value = 3.315e-07
alternative hypothesis: true location shift is not equal to 0

Warning message:
In wilcox.test.default(duckdb_griffin, duckdb_sqlsmith) :
  cannot compute exact p-value with ties

	Wilcoxon rank sum test with continuity correction

data:  mariadb_griffin and mariadb_squirrel
W = 225, p-value = 3.121e-06
alternative hypothesis: true location shift is not equal to 0

Warning message:
In wilcox.test.default(mariadb_griffin, mariadb_squirrel) :
  cannot compute exact p-value with ties

	Wilcoxon rank sum test with continuity correction

data:  mariadb_griffin and mariadb_sqlancer
W = 225, p-value = 6.517e-07
alternative hypothesis: true location shift is not equal to 0

Warning message:
In wilcox.test.default(mariadb_griffin, mariadb_sqlancer) :
  cannot compute exact p-value with ties

	Wilcoxon rank sum test with continuity correction

data:  postgres_griffin and postgres_squirrel
W = 225, p-value = 4.608e-07
alternative hypothesis: true location shift is not equal to 0

Warning message:
In wilcox.test.default(postgres_griffin, postgres_squirrel) :
  cannot compute exact p-value with ties
[EFFECT SIZE]: sqlite_griffin vs sqlite_squirrel
Vargha and Delaney A

A estimate: 0.8666667 (large)

[EFFECT SIZE]: duckdb_griffin vs duckdb_sqlsmith
Vargha and Delaney A

A estimate: 1 (large)

[EFFECT SIZE]: mariadb_griffin vs mariadb_squirrel
Vargha and Delaney A

A estimate: 1 (large)

[EFFECT SIZE]: mariadb_griffin vs mariadb_sqlancer
Vargha and Delaney A

A estimate: 1 (large)

[EFFECT SIZE]: postgres_griffin vs postgres_squirrel
Vargha and Delaney A

A estimate: 1 (large)
```