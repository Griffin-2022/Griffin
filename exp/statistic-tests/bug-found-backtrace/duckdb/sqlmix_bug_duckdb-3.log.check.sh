#!/bin/bash
# 12 unique crashs
cd sqlmix_bug_duckdb-1.logs/
grep "types.cpp:1273\|helper-c.cpp\|utf8proc.cpp:356\|utf8proc.cpp:351\|planner.cpp:44:13\|nextval.cpp:54\|duckdb::IOException\|bind_parameter_expression.cpp:10\|physical_limit.cpp:147\|stl_vector.h:1043\|catalog_set.cpp:526\|function.cpp:368" ./ -rL