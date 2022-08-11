#!/bin/bash
# 11 unique crashs
cd sqlmix_bug_duckdb-1.logs/
grep "types.cpp:1273\|helper-c.cpp\|bind_parameter_expression.cpp:10\|function.cpp:368\|types.hpp:110\|utf8proc.cpp:351\|utf8proc.cpp:356\|planner.cpp:44\|nextval.cpp:54\|duckdb::IOException\|utf8proc_wrapper.cpp:37\|string_type.cpp" ./ -rL