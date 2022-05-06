# SQLite
## sqlite-SEGV.sql

```
Program received signal SIGSEGV, Segmentation fault.
0x00000000008d18cb in sqlite3VdbeExec (p=<optimized out>) at sqlite3.c:92862
92862     rc = sqlite3BtreeInsert(pC->uc.pCursor, &x,
(gdb) bt
#0  0x00000000008d18cb in sqlite3VdbeExec (p=<optimized out>) at sqlite3.c:92862
#1  0x00000000008807c8 in sqlite3_step (pStmt=<optimized out>) at sqlite3.c:85264
#2  0x00000000004108a5 in exec_prepared_stmt (pArg=0x7ffe7dedb9c0, pStmt=<optimized out>) at shell.c:14423
#3  0x00000000004099cd in shell_exec (pArg=<optimized out>, zSql=0x610000000140 "UPDATE t1 SET b = 0;", pzErrMsg=<optimized out>) at shell.c:14738
#4  0x000000000043ceb8 in runOneSqlLine (p=<optimized out>, zSql=<optimized out>, in=<optimized out>, startline=<optimized out>) at shell.c:21956
#5  0x00000000003cb368 in process_input (p=0x7ffe7dedb9c0) at shell.c:22066
#6  0x00000000003c1895 in main (argc=<optimized out>, argv=<optimized out>) at shell.c:22890
```

## sqlite-AF.sql

```
sqlite3: sqlite3.c:126779: void sqlite3CompleteInsertion(Parse *, Table *, int, int, int, int *, int, int, int): Assertion `pParse->nested==0' failed.

Program received signal SIGABRT, Aborted.
__GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:50
50      ../sysdeps/unix/sysv/linux/raise.c: No such file or directory.
(gdb) bt
#0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:50
#1  0x00007fe574ab3859 in __GI_abort () at abort.c:79
#2  0x00007fe574ab3729 in __assert_fail_base (fmt=0x7fe574c49588 "%s%s%s:%u: %s%sAssertion `%s' failed.\n%n", assertion=0x2e1c40 <str> "pParse->nested==0", 
    file=0x263b40 <str.1> "sqlite3.c", line=126779, function=<optimized out>) at assert.c:92
#3  0x00007fe574ac4f36 in __GI___assert_fail (assertion=0x2e1c40 <str> "pParse->nested==0", file=0x263b40 <str.1> "sqlite3.c", line=126779, 
    function=0x2e1b40 <__PRETTY_FUNCTION__.sqlite3CompleteInsertion> "void sqlite3CompleteInsertion(Parse *, Table *, int, int, int, int *, int, int, int)") at assert.c:101
#4  0x000000000092278b in sqlite3CompleteInsertion (pParse=0x7ffd14ba3100, pTab=0x60b000000670, iDataCur=5, iIdxCur=5, regNewData=43, aRegIdx=0x62e00000a5a4, update_flags=4, appendBias=0, 
    useSeekResult=0) at sqlite3.c:126779
#5  0x000000000068383a in sqlite3Update (pParse=0x7ffd14ba3100, pTabList=0x62e0000096a0, pChanges=0x62e000009220, pWhere=0x62e00000a1a0, onError=11, pOrderBy=0x0, pLimit=0x0, pUpsert=0x0)
    at sqlite3.c:143715
#6  0x000000000061f3ac in yy_reduce (yypParser=0x7ffd14ba1330, yyruleno=157, yyLookahead=1, yyLookaheadToken=..., pParse=0x7ffd14ba3100) at sqlite3.c:164372
#7  0x000000000060dc64 in sqlite3Parser (yyp=0x7ffd14ba1330, yymajor=1, yyminor=...) at sqlite3.c:165425
#8  0x0000000000548600 in sqlite3RunParser (pParse=0x7ffd14ba3100, zSql=0x62e0000090de "", pzErrMsg=0x7ffd14ba1e80) at sqlite3.c:166721
#9  0x000000000089e852 in sqlite3NestedParse (pParse=0x7ffd14ba3100, zFormat=0x2e8080 <str> "UPDATE \"%w\".sqlite_sequence set name = %Q WHERE name = %Q") at sqlite3.c:113575
#10 0x00000000006b2d6f in sqlite3AlterRenameTable (pParse=0x7ffd14ba3100, pSrc=0x62e00000ae20, pName=0x7ffd14ba2678) at sqlite3.c:108450
#11 0x000000000062aa5d in yy_reduce (yypParser=0x7ffd14ba25d0, yyruleno=288, yyLookahead=1, yyLookaheadToken=..., pParse=0x7ffd14ba3100) at sqlite3.c:164945
#12 0x000000000060dc64 in sqlite3Parser (yyp=0x7ffd14ba25d0, yymajor=1, yyminor=...) at sqlite3.c:165425
#13 0x0000000000548600 in sqlite3RunParser (pParse=0x7ffd14ba3100, zSql=0x60c00000011a ";", pzErrMsg=0x7ffd14ba30e0) at sqlite3.c:166721
#14 0x00000000005354c0 in sqlite3Prepare (db=0x617000000080, zSql=0x60c000000100 "ALTER TABLE c1 RENAME TO a;", nBytes=-1, prepFlags=128, pReprepare=0x0, ppStmt=0x7ffd14ba34a0, 
    pzTail=0x7ffd14ba34c0) at sqlite3.c:133175
#15 0x0000000000533b0a in sqlite3LockAndPrepare (db=0x617000000080, zSql=0x60c000000100 "ALTER TABLE c1 RENAME TO a;", nBytes=-1, prepFlags=128, pOld=0x0, ppStmt=0x7ffd14ba34a0, 
    pzTail=0x7ffd14ba34c0) at sqlite3.c:133250
#16 0x000000000052b98f in sqlite3_prepare_v2 (db=0x617000000080, zSql=0x60c000000100 "ALTER TABLE c1 RENAME TO a;", nBytes=-1, ppStmt=0x7ffd14ba34a0, pzTail=0x7ffd14ba34c0)
    at sqlite3.c:133336
#17 0x00000000004a9d3f in shell_exec (pArg=0x7ffd14ba4080, zSql=0x60c000000100 "ALTER TABLE c1 RENAME TO a;", pzErrMsg=0x7ffd14ba3620) at shell.c:14642
#18 0x00000000004b10ee in runOneSqlLine (p=0x7ffd14ba4080, zSql=0x60c000000100 "ALTER TABLE c1 RENAME TO a;", in=0x0, startline=4) at shell.c:21957
#19 0x00000000004ad765 in process_input (p=0x7ffd14ba4080) at shell.c:22067
#20 0x0000000000479bd8 in main (argc=1, argv=0x7ffd14ba55f8) at shell.c:22892
```

# DuckDB

## duckdb-SEGV.sql

```
AddressSanitizer:DEADLYSIGNAL
=================================================================
==39778==ERROR: AddressSanitizer: SEGV on unknown address (pc 0x000001ab00b2 bp 0x7fff4c997350 sp 0x7fff4c996b08 T0)
==39778==The signal is caused by a READ memory access.
==39778==Hint: this fault was caused by a dereference of a high value address (see register values below).  Disassemble the provided pc to learn which register was used.
    #0 0x1ab00b2 in __asan::QuickCheckForUnpoisonedRegion(unsigned long, unsigned long) (/root/bld_asan/duckdb+0x1ab00b2)
    #1 0x1aaff6a in __asan_memcpy (/root/bld_asan/duckdb+0x1aaff6a)
    #2 0x2a4349e in duckdb::EncodeStringDataPrefix(unsigned char*, duckdb::string_t, unsigned long) /root/duckdb/src/common/radix.cpp:162:2
    #3 0x56835b7 in duckdb::RadixScatterStringVector(duckdb::VectorData&, duckdb::SelectionVector const&, unsigned long, unsigned char**, bool, bool, bool, unsigned long, unsigned long) /root/duckdb/src/common/row_operations/row_radix_scatter.cpp:87:4
    #4 0x56877bc in duckdb::RowOperations::RadixScatter(duckdb::Vector&, unsigned long, duckdb::SelectionVector const&, unsigned long, unsigned char**, bool, bool, bool, unsigned long, unsigned long, unsigned long) /root/duckdb/src/common/row_operations/row_radix_scatter.cpp:269:3
    #5 0x57be86a in duckdb::LocalSortState::SinkChunk(duckdb::DataChunk&, duckdb::DataChunk&) /root/duckdb/src/common/sort/sort_state.cpp:165:3
    #6 0x5cbcd86 in duckdb::SortCollectionForPartition(duckdb::WindowOperatorState&, duckdb::BoundWindowExpression*, duckdb::ChunkCollection&, duckdb::ChunkCollection&, duckdb::ChunkCollection*, unsigned long, unsigned long) /root/duckdb/src/execution/operator/aggregate/physical_window.cpp:403:20
    #7 0x5cb68d4 in duckdb::GeneratePartition(duckdb::WindowOperatorState&, duckdb::WindowGlobalState&, unsigned long) /root/duckdb/src/execution/operator/aggregate/physical_window.cpp:1221:3
    #8 0x5cb5208 in duckdb::PhysicalWindow::GetData(duckdb::ExecutionContext&, duckdb::DataChunk&, duckdb::GlobalSourceState&, duckdb::LocalSourceState&) const /root/duckdb/src/execution/operator/aggregate/physical_window.cpp:1376:4
    #9 0x3826288 in duckdb::PipelineExecutor::FetchFromSource(duckdb::DataChunk&) /root/duckdb/src/parallel/pipeline_executor.cpp:316:19
    #10 0x3818efd in duckdb::PipelineExecutor::ExecutePull(duckdb::DataChunk&) /root/duckdb/src/parallel/pipeline_executor.cpp:194:5
    #11 0x3818538 in duckdb::Executor::FetchChunk() /root/duckdb/src/parallel/executor.cpp:729:18
    #12 0x3588278 in duckdb::ClientContext::FetchInternal(duckdb::ClientContextLock&, duckdb::Executor&, duckdb::BaseQueryResult&) /root/duckdb/src/main/client_context.cpp:96:25
    #13 0x3588038 in duckdb::ClientContext::Fetch(duckdb::ClientContextLock&, duckdb::StreamQueryResult&) /root/duckdb/src/main/client_context.cpp:88:9
    #14 0x35fe8a5 in duckdb::StreamQueryResult::FetchRaw() /root/duckdb/src/main/stream_query_result.cpp:47:20
    #15 0x35f44b1 in duckdb::QueryResult::Fetch() /root/duckdb/src/main/query_result.cpp:50:15
    #16 0x1c1023e in duckdb::QueryResult::TryFetch(std::unique_ptr<duckdb::DataChunk, std::default_delete<duckdb::DataChunk> >&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /root/duckdb/src/include/duckdb/main/query_result.hpp:85:13
    #17 0x1bf98f6 in sqlite3_step /root/duckdb/tools/sqlite3_api_wrapper/sqlite3_api_wrapper.cpp:229:23
    #18 0x1bd32da in exec_prepared_stmt_columnar /root/duckdb/tools/shell/shell.c:12710:8
    #19 0x1bd0f53 in exec_prepared_stmt /root/duckdb/tools/shell/shell.c:12886:5
    #20 0x1b396ab in shell_exec /root/duckdb/tools/shell/shell.c:13204:7
    #21 0x1bdc4ca in runOneSqlLine /root/duckdb/tools/shell/shell.c:19991:8
    #22 0x1b3c71d in process_input /root/duckdb/tools/shell/shell.c:20106:17
    #23 0x1b03651 in main /root/duckdb/tools/shell/shell.c:20908:12
    #24 0x7f387b7510b2 in __libc_start_main /build/glibc-sMfBJT/glibc-2.31/csu/../csu/libc-start.c:308:16
    #25 0x1a3597d in _start (/root/bld_asan/duckdb+0x1a3597d)

AddressSanitizer can not provide additional info.
SUMMARY: AddressSanitizer: SEGV (/root/bld_asan/duckdb+0x1ab00b2) in __asan::QuickCheckForUnpoisonedRegion(unsigned long, unsigned long)
==39778==ABORTING
```
