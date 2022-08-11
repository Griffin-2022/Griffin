12 hours, 5 times repeated.

| version / built-in testcase version / initial seeds version | toolA for comparison | unique crashes found by toolA | unique crashes found by GRIFFIN |
| ------ | -------- | ------------ | ------------------ |
| 3.13.0 | SQLsmith | 1(1,1,1,1,1) | 23(15,14,18,13,12) |
| 3.28.0 | SQLancer | 5(4,5,4,4,4) | 6(3,2,3,2,2)       |
| 3.30.1 | SQUIRREL | 5(5,4,3,5,3) | 11(4,5,6,7,3)      |

### SQLite
```bash
/root/AFLplusplus/afl-clang-fast++ -g /root/target.cc -lsqlite3 -o /root/sqlite_driver_fast -lpthread -ldl
LD_PRELOAD=/root/bin_for_sqlsmith_aflpp/usr/local/lib/libsqlite3.so /root/sqlite_driver_fast


# unique assertion.
grep "assertion=0x[a-z0-9]* \"[^\"]*\"" -oh ./*core.log | grep "\"[^\"]*\"" -o | sort | uniq
# unique signal.
grep "SIG.*," -oh ./*.core.log | sort | uniq
# unique segment fault.
grep "SIGSEGV" ./*core.log -A 1 | grep "sqlite3.c:.*" -o | sort | uniq
# unique backtrace
(for x in ./*core.log; do cat "$x" | grep -v "__GI___libc_malloc\|__GI___assert_fail\|__assert_fail_base\|sqlite3_malloc\|_int_malloc\|malloc_consolidate\|sqlite3_free\|sqlite3MemFree\|_int_free\|malloc_printerr\|_GI_abort\|__libc_message\|__GI_raise" | grep "#[0-9]* *0x" -A 5 | grep ") at .*" -o | head -1; done) | sort | uniq

# common unique
(for x in $(docker container ls --format="{{.Names}}" | grep sqlancer_own_sqlite);do docker exec -it "$x" bash -c '(for x in ./*core.log; do cat "$x" | grep -v "__GI___libc_malloc\|__GI___assert_fail\|__assert_fail_base\|sqlite3_malloc\|_int_malloc\|malloc_consolidate\|sqlite3_free\|sqlite3MemFree\|_int_free\|malloc_printerr\|_GI_abort\|__libc_message\|__GI_raise" | grep "#[0-9]* *0x" -A 5 | grep ") at .*" -o | head -1; done) | sort | uniq'; done) | sort | uniq

# each unique
(for x in $(docker container ls --format="{{.Names}}" | grep sqlancer_own_sqlite);do docker exec -it "$x" bash -c '(for x in ./*core.log; do cat "$x" | grep -v "__GI___libc_malloc\|__GI___assert_fail\|__assert_fail_base\|sqlite3_malloc\|_int_malloc\|malloc_consolidate\|sqlite3_free\|sqlite3MemFree\|_int_free\|malloc_printerr\|_GI_abort\|__libc_message\|__GI_raise" | grep "#[0-9]* *0x" -A 5 | grep ") at .*" -o | head -1; done) | sort | uniq | wc -l'; done)

# unique segment fault.

# for squirrel
/root/AFLplusplus/afl-clang-lto++ -g /root/target.cc /root/bin_for_squirrel_aflpp/usr/local/lib/libsqlite3.a -o /root/sqlite_driver_fast -lpthread -ldl
for x in /root/squirrel/SQLite/fuzz_root/output/crashes/*; do echo -e "r < \"$x\"\nbt" | gdb /root/sqlite_driver_fast > /root/$RANDOM$RANDOM.core.log; done

# for sqlmix_for_sqlancer
tool=sqlancer
/root/AFLplusplus/afl-clang-lto++ -g /root/target.cc /root/bin_for_$tool_aflpp/usr/local/lib/libsqlite3.a -o /root/sqlite_driver_fast -lpthread -ldl
for x in /root/out/default/crashes/*; do echo -e "r < \"$x\"\nbt" | gdb /root/sqlite_driver_fast > /root/$RANDOM$RANDOM.core.log; done

# global script (fish)
for x in (docker container ls --format='{{.Names}}' | grep "sqlmix_for_sqlancer"); docker exec -it "$x" bash -c '/root/AFLplusplus/afl-clang-lto++ -g /root/target.cc /root/bin_for_sqlancer_aflpp/usr/local/lib/libsqlite3.a -o /root/sqlite_driver_fast -lpthread -ldl; for x in /root/out/default/crashes/*; do echo -e "r < \\"$x\\"\\nbt" | gdb /root/sqlite_driver_fast > /root/$RANDOM$RANDOM.core.log; done'; end

# global script (fish)
for x in (docker container ls --format='{{.Names}}' | grep "sqlmix_for_sqlsmith"); docker exec -it "$x" bash -c '/root/AFLplusplus/afl-clang-lto++ -g /root/target.cc /root/bin_for_sqlsmith_aflpp/usr/local/lib/libsqlite3.a -o /root/sqlite_driver_fast -lpthread -ldl; for x in /root/out/default/crashes/*; do echo -e "r < \\"$x\\"\\nbt" | gdb /root/sqlite_driver_fast > /root/$RANDOM$RANDOM.core.log; done'; end

# global script (fish)
for x in (docker container ls --format='{{.Names}}' | grep "sqlmix_for_squirrel"); docker exec -it "$x" bash -c '/root/AFLplusplus/afl-clang-lto++ -g /root/target.cc /root/bin_for_squirrel_aflpp/usr/local/lib/libsqlite3.a -o /root/sqlite_driver_fast -lpthread -ldl; for x in /root/out/default/crashes/*; do echo -e "r < \\"$x\\"\\nbt" | gdb /root/sqlite_driver_fast > /root/$RANDOM$RANDOM.core.log; done'; end

# archive core log
for x in (docker container ls --format='{{.Names}}' | grep "sqlite"); docker exec -it "$x" bash -c 'mkdir -p /root/cores/; cp /root/*.core.log /root/cores'; end
```
