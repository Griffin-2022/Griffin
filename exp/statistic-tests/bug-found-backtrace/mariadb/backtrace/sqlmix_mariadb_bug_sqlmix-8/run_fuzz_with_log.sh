#!/bin/bash
export LLVM_PROFILE_FILE="/root/default.profraw%9m%c"
SQLSIM_LOG_ERROR=1 /root/run_fuzz.sh