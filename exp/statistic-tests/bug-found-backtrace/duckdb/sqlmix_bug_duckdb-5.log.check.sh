#!/bin/bash
# 12 unique crashs
cd sqlmix_bug_duckdb-1.logs/
grep "types.cpp:1273\|helper-c.cpp\|utf8proc.cpp:351\|utf8proc.cpp:356\|function.cpp:368\|string_type.cpp\|propagate_and_compress.cpp:79\|planner.cpp:44\|deliminator.cpp:39\|nextval.cpp:57\|duckdb::IOException\|query_error_context.cpp:114" ./ -rL