#!/bin/bash

port_to_use="$1"
exe_orig="$2"

if [ -z "$exe_orig"]
then
    exe_orig=/root/bin_original/usr/local/pgsql/bin/postgres
fi

data_dir=/root/out/pg_client_dir_"$port_to_use"/
exe_name=pg_c_"$port_to_use"
exe_path=/root/out/"$exe_name"

killall -9 "$exe_name"
rm -rf "$data_dir"
mkdir "$data_dir"
/root/bin_original/usr/local/pgsql/bin/initdb -D "$data_dir"
ln -sf "$exe_orig" "$exe_path"
sed -i 's/#statement_timeout = 0/statement_timeout = 1000/'            "$data_dir"/postgresql.conf
sed -i 's/#log_error_verbosity = default/log_error_verbosity = terse/' "$data_dir"/postgresql.conf
echo "create database x;" | "$exe_path" --single -D "$data_dir"
mv /root/out/*.pg_log /root/

# setsid echo "
# handle SIGUSR1 noprint nostop
# set detach-on-fork
# r -D $data_dir -p $port_to_use > /dev/null 2>> /root/out/$RANDOM$RANDOM.pg_log
# q
# " | setsid gdb "$exe_path" >> /root/$RANDOM$RANDOM.gdb_log &

setsid "$exe_path" -D $data_dir -p $port_to_use > /dev/null 2>> /root/out/$RANDOM$RANDOM.pg_log
sleep 5
