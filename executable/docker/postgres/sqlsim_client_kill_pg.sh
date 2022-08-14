#!/bin/bash

port_to_use="$1"
data_dir=/root/out/pg_client_dir_"$port_to_use"/
exe_name=pg_c_"$port_to_use"
exe_path=/root/out/"$exe_name"

killall "$exe_name"
sleep 0.5
killall -9 "$exe_name"
