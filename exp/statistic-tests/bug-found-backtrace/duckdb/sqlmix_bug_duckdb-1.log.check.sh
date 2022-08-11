#!/bin/bash
# 11 unique crashs
cd sqlmix_bug_duckdb-1.logs/
grep "utf8proc.cpp:351:21\|/root/duckdb/src/main/capi/helper-c.cpp\|utf8proc.cpp:356:21\|function.cpp:368:29\|planner.cpp:44:13\|bitwise.cpp:148:38\|types.hpp:110:68\|types.cpp:1273:6\|nextval.cpp:54\|IOException\|date.cpp:386" ./ -r -L

# not bug?
# helper-c.cpp
# duckdb::IOException
