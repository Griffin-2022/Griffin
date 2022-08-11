#!/bin/bash
# 9 unique crashs
cd sqlmix_bug_duckdb-1.logs/
grep "types.cpp:1273\|helper-c.cpp\|utf8proc.cpp:356\|atomic_base.h:419\|duckdb::IOException\|function.cpp:368\|utf8proc.cpp:351\|planner.cpp:44\|nextval.cpp:54\|bitwise.cpp:148" ./ -rL

# not bug?
# helper-c.cpp
# duckdb::IOException
