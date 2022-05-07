# Griffin: Grammar-Free DBMS Fuzzing

Griffin is a grammar-free DBMS fuzzer. 
Unlike other DBMS relying on the grammar of DBMS's input (such as SQL) to build AST for generation or parsers for mutation,
Griffin summarizes the DBMS’s state into metadata graph, a lightweight data structure which improves mutation correctness in fuzzing.

Griffin found 55 bugs totally in SQLite, DuckDB, MariaDB, PostgreSQL, including 4 undefined behaviors, 15 assertion failures, 3 NULL pointer dereferences, 21 segmentation violations, 1 buffer-overflow, and 6 heap-use-after-free.

|     |Bug Identifier|
|-----|-----|
|SQLite(16)|CVE-2021-46100(not public yet), 12c0121,1d3760a,3b36ed7,<br>3c9f5c9,4df301c,5232c97,562805c,<br>58de3c2,5e0ed49,fdf9ed6,eb07219,<br>e199a85,73c2b50,c76a4c0,ae464a1|
|DuckDB(12)|issue#3350, #3351, #3352, #3353, #3354, #3361, #3364, #3365, #3366, #3367, #3373, #3374|
|MariaDB(24)|CVE-2022-27444, CVE-2022-27445, CVE-2022-27446, CVE-2022-27447, CVE-2022-27448, <br> CVE-2022-27449, CVE-2022-27451, CVE-2022-27452, CVE-2022-27455, <br> CVE-2022-27456, CVE-2022-27457, CVE-2022-27458,<br> MDEV-28083, MDEV-28084, MDEV-28085, MDEV-28086, MDEV-28087, MDEV-28088, MDEV-28092,<br> MDEV-28096, MDEV-28129, MDEV-28130, MDEV-28136, MDEV-28138|
|PostgreSQL(3)|bug#17151, #17316, #17317|

# Tested DBMS and Initial Seeds

|DBMS| Initial seed ref|
|-----|-----|
|SQLite|https://github.com/sqlite/sqlite/tree/master/test|
|DuckDB|https://github.com/duckdb/duckdb/tree/master/test|
|MariaDB|https://github.com/MariaDB/server/tree/10.9/mysql-test/suite|
|PostgreSQL|https://github.com/postgres/postgres/tree/master/src/test/regress/sql|

# Communication Log



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

## duckdb-NPD.sql

```
AddressSanitizer:DEADLYSIGNAL
=================================================================
==12804==ERROR: AddressSanitizer: SEGV on unknown address 0x000000000030 (pc 0x000001460dcb bp 0x7ffd665bc550 sp 0x7ffd665bc3a8 T0)
==12804==The signal is caused by a READ memory access.
==12804==Hint: address points to the zero page.
    #0 0x1460dcb in duckdb::LogicalType::LogicalType(duckdb::LogicalType const&) /root/duckdb/src/common/types.cpp:34:17
    #1 0xee5e64 in void __gnu_cxx::new_allocator<duckdb::LogicalType>::construct<duckdb::LogicalType, duckdb::LogicalType const&>(duckdb::LogicalType*, duckdb::LogicalType const&) /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/ext/new_allocator.h:147:23
    #2 0xee5e64 in void std::allocator_traits<std::allocator<duckdb::LogicalType> >::construct<duckdb::LogicalType, duckdb::LogicalType const&>(std::allocator<duckdb::LogicalType>&, duckdb::LogicalType*, duckdb::LogicalType const&) /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/alloc_traits.h:484:8
    #3 0xee5e64 in std::vector<duckdb::LogicalType, std::allocator<duckdb::LogicalType> >::push_back(duckdb::LogicalType const&) /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/stl_vector.h:1189:6
    #4 0xee5e64 in duckdb::GetLogicalTypesFromExpressions(std::vector<std::unique_ptr<duckdb::Expression, std::default_delete<duckdb::Expression> >, std::allocator<std::unique_ptr<duckdb::Expression, std::default_delete<duckdb::Expression> > > >&) /root/duckdb/src/function/function.cpp:368:9
    #5 0xed8a11 in duckdb::Function::BindFunction(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, std::vector<duckdb::ScalarFunction, std::allocator<duckdb::ScalarFunction> >&, std::vector<std::unique_ptr<duckdb::Expression, std::default_delete<duckdb::Expression> >, std::allocator<std::unique_ptr<duckdb::Expression, std::default_delete<duckdb::Expression> > > >&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /root/duckdb/src/function/function.cpp:375:15
    #6 0xed8dd3 in duckdb::ScalarFunction::BindScalarFunction(duckdb::ClientContext&, duckdb::ScalarFunctionCatalogEntry&, std::vector<std::unique_ptr<duckdb::Expression, std::default_delete<duckdb::Expression> >, std::allocator<std::unique_ptr<duckdb::Expression, std::default_delete<duckdb::Expression> > > >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&, bool) /root/duckdb/src/function/function.cpp:444:24
    #7 0x1ac1042 in duckdb::ExpressionBinder::BindFunction(duckdb::FunctionExpression&, duckdb::ScalarFunctionCatalogEntry*, unsigned long) /root/duckdb/src/planner/binder/expression/bind_function_expression.cpp:61:6
    #8 0x1ac0b09 in duckdb::ExpressionBinder::BindExpression(duckdb::FunctionExpression&, unsigned long, std::unique_ptr<duckdb::ParsedExpression, std::default_delete<duckdb::ParsedExpression> >*) /root/duckdb/src/planner/binder/expression/bind_function_expression.cpp:30:10
    #9 0x7359ba in duckdb::ExpressionBinder::BindExpression(std::unique_ptr<duckdb::ParsedExpression, std::default_delete<duckdb::ParsedExpression> >*, unsigned long, bool) /root/duckdb/src/planner/expression_binder.cpp:57:10
    #10 0x720097 in duckdb::WhereBinder::BindExpression(std::unique_ptr<duckdb::ParsedExpression, std::default_delete<duckdb::ParsedExpression> >*, unsigned long, bool) /root/duckdb/src/planner/expression_binder/where_binder.cpp:37:28
    #11 0x73614a in duckdb::ExpressionBinder::Bind[abi:cxx11](std::unique_ptr<duckdb::ParsedExpression, std::default_delete<duckdb::ParsedExpression> >*, unsigned long, bool) /root/duckdb/src/planner/expression_binder.cpp:228:22
    #12 0x72c861 in duckdb::ExpressionBinder::BindChild(std::unique_ptr<duckdb::ParsedExpression, std::default_delete<duckdb::ParsedExpression> >&, unsigned long, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /root/duckdb/src/planner/expression_binder.cpp:98:23
    #13 0x1abf5b0 in duckdb::ExpressionBinder::BindExpression(duckdb::ComparisonExpression&, unsigned long) /root/duckdb/src/planner/binder/expression/bind_comparison_expression.cpp:116:2
    #14 0x73599a in duckdb::ExpressionBinder::BindExpression(std::unique_ptr<duckdb::ParsedExpression, std::default_delete<duckdb::ParsedExpression> >*, unsigned long, bool) /root/duckdb/src/planner/expression_binder.cpp:50:10
    #15 0x720097 in duckdb::WhereBinder::BindExpression(std::unique_ptr<duckdb::ParsedExpression, std::default_delete<duckdb::ParsedExpression> >*, unsigned long, bool) /root/duckdb/src/planner/expression_binder/where_binder.cpp:37:28
    #16 0x73614a in duckdb::ExpressionBinder::Bind[abi:cxx11](std::unique_ptr<duckdb::ParsedExpression, std::default_delete<duckdb::ParsedExpression> >*, unsigned long, bool) /root/duckdb/src/planner/expression_binder.cpp:228:22
    #17 0x735cd6 in duckdb::ExpressionBinder::BindCorrelatedColumns(std::unique_ptr<duckdb::ParsedExpression, std::default_delete<duckdb::ParsedExpression> >&) /root/duckdb/src/planner/expression_binder.cpp:84:35
    #18 0x737e18 in duckdb::ExpressionBinder::Bind(std::unique_ptr<duckdb::ParsedExpression, std::default_delete<duckdb::ParsedExpression> >&, duckdb::LogicalType*, bool) /root/duckdb/src/planner/expression_binder.cpp:187:18
    #19 0x1ad6b83 in duckdb::Binder::BindNode(duckdb::SelectNode&) /root/duckdb/src/planner/binder/query_node/bind_select_node.cpp:374:29
    #20 0x73bc5d in duckdb::Binder::BindNode(duckdb::QueryNode&) /root/duckdb/src/planner/binder.cpp:94:12
    #21 0x1ac6052 in duckdb::ExpressionBinder::BindExpression(duckdb::SubqueryExpression&, unsigned long) /root/duckdb/src/planner/binder/expression/bind_subquery_expression.cpp:40:38
    #22 0x7358ae in duckdb::ExpressionBinder::BindExpression(std::unique_ptr<duckdb::ParsedExpression, std::default_delete<duckdb::ParsedExpression> >*, unsigned long, bool) /root/duckdb/src/planner/expression_binder.cpp:63:10
    #23 0x720097 in duckdb::WhereBinder::BindExpression(std::unique_ptr<duckdb::ParsedExpression, std::default_delete<duckdb::ParsedExpression> >*, unsigned long, bool) /root/duckdb/src/planner/expression_binder/where_binder.cpp:37:28
    #24 0x73614a in duckdb::ExpressionBinder::Bind[abi:cxx11](std::unique_ptr<duckdb::ParsedExpression, std::default_delete<duckdb::ParsedExpression> >*, unsigned long, bool) /root/duckdb/src/planner/expression_binder.cpp:228:22
    #25 0x737e05 in duckdb::ExpressionBinder::Bind(std::unique_ptr<duckdb::ParsedExpression, std::default_delete<duckdb::ParsedExpression> >&, duckdb::LogicalType*, bool) /root/duckdb/src/planner/expression_binder.cpp:184:19
    #26 0x7067e1 in duckdb::Binder::Bind(duckdb::JoinRef&) /root/duckdb/src/planner/binder/tableref/bind_joinref.cpp:234:30
    #27 0x73c315 in duckdb::Binder::Bind(duckdb::TableRef&) /root/duckdb/src/planner/binder.cpp:142:12
    #28 0x1ad5291 in duckdb::Binder::BindNode(duckdb::SelectNode&) /root/duckdb/src/planner/binder/query_node/bind_select_node.cpp:266:23
    #29 0x73bc5d in duckdb::Binder::BindNode(duckdb::QueryNode&) /root/duckdb/src/planner/binder.cpp:94:12
    #30 0x73bd1b in duckdb::Binder::Bind(duckdb::QueryNode&) /root/duckdb/src/planner/binder.cpp:108:20
    #31 0x6c2630 in duckdb::Binder::Bind(duckdb::SelectStatement&) /root/duckdb/src/planner/binder/statement/bind_select.cpp:9:9
    #32 0x73b746 in duckdb::Binder::Bind(duckdb::SQLStatement&) /root/duckdb/src/planner/binder.cpp:44:10
    #33 0x744395 in duckdb::Planner::CreatePlan(duckdb::SQLStatement&) /root/duckdb/src/planner/planner.cpp:31:33
    #34 0x514010 in duckdb::ClientContext::CreatePreparedStatement(duckdb::ClientContextLock&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >) /root/duckdb/src/main/client_context.cpp:251:10
    #35 0x51591e in duckdb::ClientContext::PendingStatementInternal(duckdb::ClientContextLock&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >) /root/duckdb/src/main/client_context.cpp:482:18
    #36 0x5178af in duckdb::ClientContext::PendingStatementOrPreparedStatement(duckdb::ClientContextLock&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >, std::shared_ptr<duckdb::PreparedStatementData>&, std::vector<duckdb::Value, std::allocator<duckdb::Value> >*) /root/duckdb/src/main/client_context.cpp:557:13
    #37 0x515492 in duckdb::ClientContext::PendingStatementOrPreparedStatementInternal(duckdb::ClientContextLock&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >, std::shared_ptr<duckdb::PreparedStatementData>&, std::vector<duckdb::Value, std::allocator<duckdb::Value> >*) /root/duckdb/src/main/client_context.cpp:541:9
    #38 0x5341e3 in duckdb::ClientContext::PendingQueryInternal(duckdb::ClientContextLock&, std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >, bool) /root/duckdb/src/main/client_context.cpp:692:10
    #39 0x518319 in duckdb::ClientContext::Query(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, bool) /root/duckdb/src/main/client_context.cpp:634:24
    #40 0x519c06 in duckdb::Connection::Query(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) /root/duckdb/src/main/connection.cpp:71:25
    #41 0x4e57c8 in duckdb_query /root/duckdb/src/main/capi/duckdb-c.cpp:67:22
    #42 0x4e10d3 in run_one_statement_new(void*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) /mnt/jingzhou_workspace/sqlsim/client_new/duckdb/client_new.cpp:57:13
    #43 0x4d3984 in run_testcase(void*&, char const*, int) /root/autodriver.cpp:102:14
    #44 0x4d8601 in do_fuzz()::$_3::operator()() const /root/autodriver.cpp:227:13
    #45 0x4d809e in do_fuzz() /root/autodriver.cpp:235:13
    #46 0x4d8b43 in main /root/autodriver.cpp:292:9
    #47 0x7f107cf9e0b2 in __libc_start_main /build/glibc-sMfBJT/glibc-2.31/csu/../csu/libc-start.c:308:16
    #48 0x4247ad in _start (/root/autodriver+0x4247ad)
```

## duckdb-UAF.sql

```
==61101==ERROR: AddressSanitizer: heap-use-after-free on address 0x60c0000193c0 at pc 0x0000036e5e2c bp 0x7fffa2af7e10 sp 0x7fffa2af7e08
READ of size 1 at 0x60c0000193c0 thread T0
    #0 0x36e5e2b in duckdb::LogicalType::operator==(duckdb::LogicalType const&) const /root/duckdb/src/common/types.cpp:1388:6
    #1 0x3a8046c in duckdb::ExpressionExecutor::Execute(duckdb::BoundParameterExpression const&, duckdb::ExpressionState*, duckdb::SelectionVector const*, unsigned long, duckdb::Vector&) /root/duckdb/src/execution/expression_executor/execute_parameter.cpp:17:2
    #2 0x44b2184 in duckdb::ExpressionExecutor::Execute(duckdb::Expression const&, duckdb::ExpressionState*, duckdb::SelectionVector const*, unsigned long, duckdb::Vector&) /root/duckdb/src/execution/expression_executor.cpp:179:3
    #3 0x44ad550 in duckdb::ExpressionExecutor::ExecuteExpression(unsigned long, duckdb::Vector&) /root/duckdb/src/execution/expression_executor.cpp:75:2
    #4 0x44ac004 in duckdb::ExpressionExecutor::Execute(duckdb::DataChunk*, duckdb::DataChunk&) /root/duckdb/src/execution/expression_executor.cpp:46:3
    #5 0x413d93c in duckdb::ExpressionExecutor::Execute(duckdb::DataChunk&, duckdb::DataChunk&) /root/duckdb/src/include/duckdb/execution/expression_executor.hpp:32:3
    #6 0xa0d0f56 in duckdb::PhysicalProjection::Execute(duckdb::ExecutionContext&, duckdb::DataChunk&, duckdb::DataChunk&, duckdb::GlobalOperatorState&, duckdb::OperatorState&) const /root/duckdb/src/execution/operator/projection/physical_projection.cpp:29:17
    #7 0x4a523ef in duckdb::PipelineExecutor::Execute(duckdb::DataChunk&, duckdb::DataChunk&, unsigned long) /root/duckdb/src/parallel/pipeline_executor.cpp:275:36
    #8 0x4a2ff57 in duckdb::PipelineExecutor::ExecutePull(duckdb::DataChunk&) /root/duckdb/src/parallel/pipeline_executor.cpp:200:5
    #9 0x4a2e480 in duckdb::Executor::FetchChunk() /root/duckdb/src/parallel/executor.cpp:729:18
    #10 0x46eab4d in duckdb::ClientContext::FetchInternal(duckdb::ClientContextLock&, duckdb::Executor&, duckdb::BaseQueryResult&) /root/duckdb/src/main/client_context.cpp:96:25
    #11 0x46ea4e2 in duckdb::ClientContext::Fetch(duckdb::ClientContextLock&, duckdb::StreamQueryResult&) /root/duckdb/src/main/client_context.cpp:88:9
    #12 0x4798d50 in duckdb::StreamQueryResult::FetchRaw() /root/duckdb/src/main/stream_query_result.cpp:47:20
    #13 0x47867b7 in duckdb::QueryResult::Fetch() /root/duckdb/src/main/query_result.cpp:50:15
    #14 0x1cdb59e in duckdb::QueryResult::TryFetch(std::unique_ptr<duckdb::DataChunk, std::default_delete<duckdb::DataChunk> >&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /root/duckdb/src/include/duckdb/main/query_result.hpp:85:13
    #15 0x1cd819c in sqlite3_step /root/duckdb/tools/sqlite3_api_wrapper/sqlite3_api_wrapper.cpp:229:23
    #16 0x1c900ea in exec_prepared_stmt_columnar /root/duckdb/tools/shell/shell.c:12710:8
    #17 0x1c8bd27 in exec_prepared_stmt /root/duckdb/tools/shell/shell.c:12886:5
    #18 0x1b7f8b3 in shell_exec /root/duckdb/tools/shell/shell.c:13204:7
    #19 0x1ca01d5 in runOneSqlLine /root/duckdb/tools/shell/shell.c:19991:8
    #20 0x1b85691 in process_input /root/duckdb/tools/shell/shell.c:20106:17
    #21 0x1b1d1db in main /root/duckdb/tools/shell/shell.c:20908:12
    #22 0x7fb79fd590b2 in __libc_start_main /build/glibc-sMfBJT/glibc-2.31/csu/../csu/libc-start.c:308:16
    #23 0x1a379fd in _start (/root/bld_asan_debug/duckdb+0x1a379fd)

0x60c0000193c0 is located 0 bytes inside of 128-byte region [0x60c0000193c0,0x60c000019440)
freed by thread T0 here:
    #0 0x1ae457d in operator delete(void*) (/root/bld_asan_debug/duckdb+0x1ae457d)
    #1 0x47a474a in std::default_delete<duckdb::Value>::operator()(duckdb::Value*) const /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/unique_ptr.h:81:2
    #2 0x47a416a in std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >::~unique_ptr() /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/unique_ptr.h:292:4
    #3 0x47a3da0 in void std::_Destroy<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > >(std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >*) /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/stl_construct.h:98:19
    #4 0x47a3bca in void std::_Destroy_aux<false>::__destroy<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >*>(std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >*, std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >*) /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/stl_construct.h:108:6
    #5 0x47a3af4 in void std::_Destroy<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >*>(std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >*, std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >*) /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/stl_construct.h:136:7
    #6 0x47a33dc in void std::_Destroy<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >*, std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > >(std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >*, std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >*, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > >&) /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/stl_construct.h:206:7
    #7 0x47a32db in std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > >::~vector() /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/stl_vector.h:677:2
    #8 0x47a2e3c in std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > >::~pair() /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/stl_pair.h:208:12
    #9 0x47a2d4e in void __gnu_cxx::new_allocator<std::__detail::_Hash_node<std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > >, false> >::destroy<std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > > >(std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > >*) /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/ext/new_allocator.h:152:10
    #10 0x47a2916 in void std::allocator_traits<std::allocator<std::__detail::_Hash_node<std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > >, false> > >::destroy<std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > > >(std::allocator<std::__detail::_Hash_node<std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > >, false> >&, std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > >*) /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/alloc_traits.h:496:8
    #11 0x47a2827 in std::__detail::_Hashtable_alloc<std::allocator<std::__detail::_Hash_node<std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > >, false> > >::_M_deallocate_node(std::__detail::_Hash_node<std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > >, false>*) /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/hashtable_policy.h:2102:7
    #12 0x47a18e7 in std::__detail::_Hashtable_alloc<std::allocator<std::__detail::_Hash_node<std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > >, false> > >::_M_deallocate_nodes(std::__detail::_Hash_node<std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > >, false>*) /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/hashtable_policy.h:2124:4
    #13 0x47f8576 in std::_Hashtable<unsigned long, std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > >, std::allocator<std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > > >, std::__detail::_Select1st, std::equal_to<unsigned long>, std::hash<unsigned long>, std::__detail::_Mod_range_hashing, std::__detail::_Default_ranged_hash, std::__detail::_Prime_rehash_policy, std::__detail::_Hashtable_traits<false, false, true> >::clear() /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/hashtable.h:2063:13
    #14 0x47f83b8 in std::_Hashtable<unsigned long, std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > >, std::allocator<std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > > >, std::__detail::_Select1st, std::equal_to<unsigned long>, std::hash<unsigned long>, std::__detail::_Mod_range_hashing, std::__detail::_Default_ranged_hash, std::__detail::_Prime_rehash_policy, std::__detail::_Hashtable_traits<false, false, true> >::~_Hashtable() /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/hashtable.h:1387:7
    #15 0x474e2b8 in std::unordered_map<unsigned long, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > >, std::hash<unsigned long>, std::equal_to<unsigned long>, std::allocator<std::pair<unsigned long const, std::vector<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> >, std::allocator<std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > > > > > >::~unordered_map() /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/unordered_map.h:102:11
    #16 0x474e1b6 in duckdb::PreparedStatementData::~PreparedStatementData() /root/duckdb/src/main/prepared_statement_data.cpp:12:1
    #17 0x487c9ee in void __gnu_cxx::new_allocator<duckdb::PreparedStatementData>::destroy<duckdb::PreparedStatementData>(duckdb::PreparedStatementData*) /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/ext/new_allocator.h:152:10
    #18 0x487c686 in void std::allocator_traits<std::allocator<duckdb::PreparedStatementData> >::destroy<duckdb::PreparedStatementData>(std::allocator<duckdb::PreparedStatementData>&, duckdb::PreparedStatementData*) /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/alloc_traits.h:496:8
    #19 0x487b735 in std::_Sp_counted_ptr_inplace<duckdb::PreparedStatementData, std::allocator<duckdb::PreparedStatementData>, (__gnu_cxx::_Lock_policy)2>::_M_dispose() /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/shared_ptr_base.h:557:2
    #20 0x1d0b943 in std::_Sp_counted_base<(__gnu_cxx::_Lock_policy)2>::_M_release() /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/shared_ptr_base.h:155:6
    #21 0x1d0b5fc in std::__shared_count<(__gnu_cxx::_Lock_policy)2>::~__shared_count() /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/shared_ptr_base.h:730:11
    #22 0x380edbc in std::__shared_ptr<duckdb::PreparedStatementData, (__gnu_cxx::_Lock_policy)2>::~__shared_ptr() /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/shared_ptr_base.h:1169:31
    #23 0x46fa8c8 in std::shared_ptr<duckdb::PreparedStatementData>::~shared_ptr() /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/shared_ptr.h:103:11
    #24 0x5da2406 in duckdb::Planner::PlanExecute(std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >) /root/duckdb/src/planner/planner.cpp:126:1
    #25 0x5d9e1a5 in duckdb::Planner::CreatePlan(std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >) /root/duckdb/src/planner/planner.cpp:168:3
    #26 0x4612bee in duckdb::ClientContext::CreatePreparedStatement(duckdb::ClientContextLock&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >) /root/duckdb/src/main/client_context.cpp:251:10
    #27 0x4881efc in duckdb::ClientContext::PrepareInternal(duckdb::ClientContextLock&, std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >)::$_1::operator()() const /root/duckdb/src/main/client_context.cpp:416:36
    #28 0x488103c in std::_Function_handler<void (), duckdb::ClientContext::PrepareInternal(duckdb::ClientContextLock&, std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >)::$_1>::_M_invoke(std::_Any_data const&) /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/std_function.h:300:2
    #29 0x4714e43 in std::function<void ()>::operator()() const /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/std_function.h:688:14

previously allocated by thread T0 here:
    #0 0x1ae3d1d in operator new(unsigned long) (/root/bld_asan_debug/duckdb+0x1ae3d1d)
    #1 0x5d9a03a in std::unique_ptr<duckdb::Value, std::default_delete<duckdb::Value> > duckdb::make_unique<duckdb::Value, duckdb::LogicalType&>(duckdb::LogicalType&) /root/duckdb/src/include/duckdb/common/helper.hpp:41:23
    #2 0x5d97c06 in duckdb::Planner::CreatePlan(duckdb::SQLStatement&) /root/duckdb/src/planner/planner.cpp:47:16
    #3 0x5d9e0a8 in duckdb::Planner::CreatePlan(std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >) /root/duckdb/src/planner/planner.cpp:165:3
    #4 0x5d9bcb8 in duckdb::Planner::PrepareSQLStatement(std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >) /root/duckdb/src/planner/planner.cpp:64:2
    #5 0x5da011f in duckdb::Planner::PlanExecute(std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >) /root/duckdb/src/planner/planner.cpp:94:14
    #6 0x5d9e1a5 in duckdb::Planner::CreatePlan(std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >) /root/duckdb/src/planner/planner.cpp:168:3
    #7 0x4612bee in duckdb::ClientContext::CreatePreparedStatement(duckdb::ClientContextLock&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >) /root/duckdb/src/main/client_context.cpp:251:10
    #8 0x4881efc in duckdb::ClientContext::PrepareInternal(duckdb::ClientContextLock&, std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >)::$_1::operator()() const /root/duckdb/src/main/client_context.cpp:416:36
    #9 0x488103c in std::_Function_handler<void (), duckdb::ClientContext::PrepareInternal(duckdb::ClientContextLock&, std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >)::$_1>::_M_invoke(std::_Any_data const&) /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/std_function.h:300:2
    #10 0x4714e43 in std::function<void ()>::operator()() const /usr/lib/gcc/x86_64-linux-gnu/9/../../../../include/c++/9/bits/std_function.h:688:14
    #11 0x47054ce in duckdb::ClientContext::RunFunctionInTransactionInternal(duckdb::ClientContextLock&, std::function<void ()> const&, bool) /root/duckdb/src/main/client_context.cpp:939:3
    #12 0x4706b37 in duckdb::ClientContext::PrepareInternal(duckdb::ClientContextLock&, std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >) /root/duckdb/src/main/client_context.cpp:415:2
    #13 0x47083fa in duckdb::ClientContext::Prepare(std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >) /root/duckdb/src/main/client_context.cpp:426:10
    #14 0x4728d33 in duckdb::Connection::Prepare(std::unique_ptr<duckdb::SQLStatement, std::default_delete<duckdb::SQLStatement> >) /root/duckdb/src/main/connection.cpp:95:18
    #15 0x1cd10c9 in sqlite3_prepare_v2 /root/duckdb/tools/sqlite3_api_wrapper/sqlite3_api_wrapper.cpp:164:28
    #16 0x1b7cd09 in shell_exec /root/duckdb/tools/shell/shell.c:13110:10
    #17 0x1ca01d5 in runOneSqlLine /root/duckdb/tools/shell/shell.c:19991:8
    #18 0x1b85691 in process_input /root/duckdb/tools/shell/shell.c:20106:17
    #19 0x1b1d1db in main /root/duckdb/tools/shell/shell.c:20908:12
    #20 0x7fb79fd590b2 in __libc_start_main /build/glibc-sMfBJT/glibc-2.31/csu/../csu/libc-start.c:308:16

SUMMARY: AddressSanitizer: heap-use-after-free /root/duckdb/src/common/types.cpp:1388:6 in duckdb::LogicalType::operator==(duckdb::LogicalType const&) const
Shadow bytes around the buggy address:
  0x0c187fffb220: fd fd fd fd fd fd fd fd fa fa fa fa fa fa fa fa
  0x0c187fffb230: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c187fffb240: fa fa fa fa fa fa fa fa fd fd fd fd fd fd fd fd
  0x0c187fffb250: fd fd fd fd fd fd fd fd fa fa fa fa fa fa fa fa
  0x0c187fffb260: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>0x0c187fffb270: fa fa fa fa fa fa fa fa[fd]fd fd fd fd fd fd fd
  0x0c187fffb280: fd fd fd fd fd fd fd fd fa fa fa fa fa fa fa fa
  0x0c187fffb290: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c187fffb2a0: fa fa fa fa fa fa fa fa fd fd fd fd fd fd fd fd
  0x0c187fffb2b0: fd fd fd fd fd fd fd fd fa fa fa fa fa fa fa fa
  0x0c187fffb2c0: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07 
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
  Shadow gap:              cc
==61101==ABORTING
```

# MariaDB
## MariaDB-UAF.sql

```
=================================================================
==12446==ERROR: AddressSanitizer: heap-use-after-free on address 0x6250000862e8 at pc 0x000000b9e5a4 bp 0x7f17b124ce90 sp 0x7f17b124ce88
WRITE of size 8 at 0x6250000862e8 thread T15
    #0 0xb9e5a3 in lex_end_nops(LEX*) /root/mariadb/sql/sql_lex.cc:1372:14
    #1 0xb9e5a3 in lex_end(LEX*) /root/mariadb/sql/sql_lex.cc:1340:3
    #2 0xb03989 in THD::end_statement() /root/mariadb/sql/sql_class.cc:3908:3
    #3 0xc4a897 in mysql_parse(THD*, char*, unsigned int, Parser_state*) /root/mariadb/sql/sql_parse.cc:8049:10
    #4 0xc41ba9 in dispatch_command(enum_server_command, THD*, char*, unsigned int, bool) /root/mariadb/sql/sql_parse.cc:1894:7
    #5 0xc4b74b in do_command(THD*, bool) /root/mariadb/sql/sql_parse.cc:1402:17
    #6 0x111f9f2 in do_handle_one_connection(CONNECT*, bool) /root/mariadb/sql/sql_connect.cc:1418:11
    #7 0x111f248 in handle_one_connection /root/mariadb/sql/sql_connect.cc:1312:5
    #8 0x1f3f9dd in pfs_spawn_thread /root/mariadb/storage/perfschema/pfs.cc:2201:3
    #9 0x7f17d6fdc608 in start_thread /build/glibc-sMfBJT/glibc-2.31/nptl/pthread_create.c:477:8
    #10 0x7f17d6cf2162 in clone /build/glibc-sMfBJT/glibc-2.31/misc/../sysdeps/unix/sysv/linux/x86_64/clone.S:95

0x6250000862e8 is located 6632 bytes inside of 8208-byte region [0x625000084900,0x625000086910)
freed by thread T15 here:
    #0 0x80f732 in free (/usr/local/mysql/bin/mariadbd+0x80f732)
    #1 0x2a598bf in root_free /root/mariadb/mysys/my_alloc.c:78:5
    #2 0x2a598bf in free_root /root/mariadb/mysys/my_alloc.c:501:7
    #3 0x9a1258 in sp_head::destroy(sp_head*) /root/mariadb/sql/sp_head.cc:521:5
    #4 0xb9e41e in lex_end_nops(LEX*) /root/mariadb/sql/sql_lex.cc:1371:3
    #5 0xb9e41e in lex_end(LEX*) /root/mariadb/sql/sql_lex.cc:1340:3
    #6 0xb03989 in THD::end_statement() /root/mariadb/sql/sql_class.cc:3908:3
    #7 0xc4a897 in mysql_parse(THD*, char*, unsigned int, Parser_state*) /root/mariadb/sql/sql_parse.cc:8049:10
    #8 0xc41ba9 in dispatch_command(enum_server_command, THD*, char*, unsigned int, bool) /root/mariadb/sql/sql_parse.cc:1894:7
    #9 0xc4b74b in do_command(THD*, bool) /root/mariadb/sql/sql_parse.cc:1402:17
    #10 0x111f9f2 in do_handle_one_connection(CONNECT*, bool) /root/mariadb/sql/sql_connect.cc:1418:11
    #11 0x111f248 in handle_one_connection /root/mariadb/sql/sql_connect.cc:1312:5
    #12 0x1f3f9dd in pfs_spawn_thread /root/mariadb/storage/perfschema/pfs.cc:2201:3
    #13 0x7f17d6fdc608 in start_thread /build/glibc-sMfBJT/glibc-2.31/nptl/pthread_create.c:477:8

previously allocated by thread T15 here:
    #0 0x80f99d in malloc (/usr/local/mysql/bin/mariadbd+0x80f99d)
    #1 0x2a76878 in my_malloc /root/mariadb/mysys/my_malloc.c:90:29
    #2 0x2a5887f in root_alloc /root/mariadb/mysys/my_alloc.c:66:10
    #3 0x2a5887f in alloc_root /root/mariadb/mysys/my_alloc.c:332:29
    #4 0x9b45f6 in Sql_alloc::operator new(unsigned long, st_mem_root*) /root/mariadb/sql/sql_alloc.h:37:12
    #5 0x9b45f6 in sp_head::reset_lex(THD*) /root/mariadb/sql/sp_head.cc:2619:25
    #6 0x1424874 in MYSQLparse(THD*) /root/mariadb/sql/sql_yacc.yy:3675:26
    #7 0xc808a0 in parse_sql(THD*, Parser_state*, Object_creation_ctx*, bool) /root/mariadb/sql/sql_parse.cc:10379:46
    #8 0xc4a263 in mysql_parse(THD*, char*, unsigned int, Parser_state*) /root/mariadb/sql/sql_parse.cc:7979:15
    #9 0xc41ba9 in dispatch_command(enum_server_command, THD*, char*, unsigned int, bool) /root/mariadb/sql/sql_parse.cc:1894:7
    #10 0xc4b74b in do_command(THD*, bool) /root/mariadb/sql/sql_parse.cc:1402:17
    #11 0x111f9f2 in do_handle_one_connection(CONNECT*, bool) /root/mariadb/sql/sql_connect.cc:1418:11
    #12 0x111f248 in handle_one_connection /root/mariadb/sql/sql_connect.cc:1312:5
    #13 0x1f3f9dd in pfs_spawn_thread /root/mariadb/storage/perfschema/pfs.cc:2201:3
    #14 0x7f17d6fdc608 in start_thread /build/glibc-sMfBJT/glibc-2.31/nptl/pthread_create.c:477:8

Thread T15 created by T0 here:
    #0 0x7f9cfc in pthread_create (/usr/local/mysql/bin/mariadbd+0x7f9cfc)
    #1 0x1f3fd39 in my_thread_create(unsigned long*, pthread_attr_t const*, void* (*)(void*), void*) /root/mariadb/storage/perfschema/my_thread.h:52:10
    #2 0x1f3fd39 in pfs_spawn_thread_v1 /root/mariadb/storage/perfschema/pfs.cc:2252:15
    #3 0x85cef4 in inline_mysql_thread_create(unsigned int, unsigned long*, pthread_attr_t const*, void* (*)(void*), void*) /root/mariadb/include/mysql/psi/mysql_thread.h:1139:11
    #4 0x85cef4 in create_thread_to_handle_connection(CONNECT*) /root/mariadb/sql/mysqld.cc:5975:19
    #5 0x85e72a in create_new_thread(CONNECT*) /root/mariadb/sql/mysqld.cc:6034:3
    #6 0x85e72a in handle_accepted_socket(st_mysql_socket, st_mysql_socket) /root/mariadb/sql/mysqld.cc:6096:5
    #7 0x85a34c in handle_connections_sockets() /root/mariadb/sql/mysqld.cc:6220:9
    #8 0x84e9ef in mysqld_main(int, char**) /root/mariadb/sql/mysqld.cc:5870:3
    #9 0x7f17d6bf70b2 in __libc_start_main /build/glibc-sMfBJT/glibc-2.31/csu/../csu/libc-start.c:308:16

SUMMARY: AddressSanitizer: heap-use-after-free /root/mariadb/sql/sql_lex.cc:1372:14 in lex_end_nops(LEX*)
Shadow bytes around the buggy address:
  0x0c4a80008c00: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c4a80008c10: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c4a80008c20: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c4a80008c30: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c4a80008c40: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
=>0x0c4a80008c50: fd fd fd fd fd fd fd fd fd fd fd fd fd[fd]fd fd
  0x0c4a80008c60: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c4a80008c70: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c4a80008c80: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c4a80008c90: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c4a80008ca0: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07 
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
  Shadow gap:              cc
==12446==ABORTING
```

## MariaDB-AF.sql

```
Thread pointer: 0x62b00015e218
Attempting backtrace. You can use the following information to find out
where mysqld died. If you see no messages after this, something went
terribly wrong...
stack_bottom = 0x7f20978f3680 thread_stack 0x5fc00
??:0(__interceptor_backtrace)[0x7cbadb]
mysys/stacktrace.c:212(my_print_stacktrace)[0x2a86d37]
sql/signal_handler.cc:0(handle_fatal_signal)[0x15af5d9]
sigaction.c:0(__restore_rt)[0x7f20bdea23c0]
??:0(gsignal)[0x7f20bdad003b]
??:0(abort)[0x7f20bdaaf859]
ut/ut0dbg.cc:40(ut_dbg_assertion_failed(char const*, char const*, unsigned int))[0x25a393e]
include/dyn0buf.h:436(mtr_buf_t::has_space(unsigned long))[0x2405186]
row/row0ins.cc:3331(row_ins_sec_index_entry(dict_index_t*, dtuple_t*, que_thr_t*, bool))[0x2407669]
row/row0ins.cc:3704(row_ins(ins_node_t*, que_thr_t*))[0x2409c07]
:0(row_insert_for_mysql(unsigned char const*, row_prebuilt_t*, ins_mode_t))[0x24470e3]
handler/ha_innodb.cc:7800(ha_innobase::write_row(unsigned char const*))[0x2169c58]
sql/handler.cc:7522(handler::ha_write_row(unsigned char const*))[0x15ecac0]
sql/sql_insert.cc:2156(write_record(THD*, TABLE*, st_copy_info*, select_result*))[0xb72ac3]
sql/sql_insert.cc:1128(mysql_insert(THD*, TABLE_LIST*, List<Item>&, List<List<Item> >&, List<Item>&, List<Item>&, enum_duplicates, bool, select_result*))[0xb6933b]
sql/sql_parse.cc:4562(mysql_execute_command(THD*, bool))[0xc68511]
sql/sql_class.h:2734(THD::enter_stage(PSI_stage_info_v1 const*, char const*, char const*, unsigned int))[0xc4a67f]
sql/sql_parse.cc:1894(dispatch_command(enum_server_command, THD*, char*, unsigned int, bool))[0xc41baa]
sql/sql_parse.cc:1404(do_command(THD*, bool))[0xc4b74c]
sql/sql_connect.cc:1418(do_handle_one_connection(CONNECT*, bool))[0x111f9f3]
sql/sql_connect.cc:0(handle_one_connection)[0x111f249]
perfschema/pfs.cc:2203(pfs_spawn_thread)[0x1f3f9de]
nptl/pthread_create.c:478(start_thread)[0x7f20bde96609]
??:0(clone)[0x7f20bdbac163]

Trying to get some variables.
Some pointers may be invalid and cause the dump to abort.
Query (0x629000087238): INSERT INTO a (keyc) VALUES(0),(1),(2),(3),(4),(5),(6),(7),(8),(9)
```

## MariaDB-SEGV.sql

```
Thread pointer: 0x62b00015e218
Attempting backtrace. You can use the following information to find out
where mysqld died. If you see no messages after this, something went
terribly wrong...
stack_bottom = 0x7f9e1a217680 thread_stack 0x5fc00
??:0(__interceptor_backtrace)[0x7cbadb]
mysys/stacktrace.c:212(my_print_stacktrace)[0x2a86d37]
sql/signal_handler.cc:0(handle_fatal_signal)[0x15af5d9]
sigaction.c:0(__restore_rt)[0x7f9e417f43c0]
mysys/tree.c:502(tree_search_next)[0x2a9a51c]
:0(heap_rprev)[0x214b1bb]
sql/handler.cc:3524(handler::ha_index_prev(unsigned char*))[0x15c8b2e]
??:0(mysql_ha_read(THD*, TABLE_LIST*, enum_ha_read_modes, char const*, List<Item>*, ha_rkey_function, Item*, unsigned long long, unsigned long long))[0xb60f2b]
sql/sql_parse.cc:5588(mysql_execute_command(THD*, bool))[0xc601de]
sql/sql_class.h:2734(THD::enter_stage(PSI_stage_info_v1 const*, char const*, char const*, unsigned int))[0xc4a67f]
sql/sql_parse.cc:1894(dispatch_command(enum_server_command, THD*, char*, unsigned int, bool))[0xc41baa]
sql/sql_parse.cc:1404(do_command(THD*, bool))[0xc4b74c]
sql/sql_connect.cc:1418(do_handle_one_connection(CONNECT*, bool))[0x111f9f3]
sql/sql_connect.cc:0(handle_one_connection)[0x111f249]
perfschema/pfs.cc:2203(pfs_spawn_thread)[0x1f3f9de]
nptl/pthread_create.c:478(start_thread)[0x7f9e417e8609]
??:0(clone)[0x7f9e414fe163]

Trying to get some variables.
Some pointers may be invalid and cause the dump to abort.
Query (0x629000087238): HANDLER v READ pk PREV
```
