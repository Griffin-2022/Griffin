#!/bin/bash
# 10 unique crashs
cd sqlmix_bug_duckdb-1.logs/
grep "helper-c.cpp\|types.cpp:1273\|utf8proc.cpp:356\|utf8proc.cpp:351\|function.cpp:368\|local_storage.cpp:268\|nextval.cpp:54\|nextval.cpp:57\|planner.cpp:44\|duckdb::IOException" ./ -rL