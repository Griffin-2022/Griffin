#!/bin/bash

port_to_use="$1"

exe_name=my_"$port_to_use"

killall "$exe_name"
sleep 0.5
killall -9 "$exe_name"
