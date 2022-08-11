#!/bin/bash
# 9 unique crashs
cd sqlmix_bug_duckdb-1.logs/
grep "types.cpp:1273:6\|helper-c.cpp\|utf8proc.cpp:356\|utf8proc.cpp:351\|propagate_and_compress.cpp:79\|utf8proc.cpp:356\|nextval.cpp:54\|function.cpp:368\|planner.cpp:44" -L ./ -r