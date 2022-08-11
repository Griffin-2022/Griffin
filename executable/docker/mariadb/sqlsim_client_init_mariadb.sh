#!/bin/bash

port_to_use="$1"
exe_orig="$2"

if [ -z "$exe_orig" ]
then
    exe_orig=/root/bin_original/usr/local/mysql/bin/mysqld
fi

data_dir=/root/out/mysql_client_dir_"$port_to_use"/
exe_name=my_"$port_to_use"
exe_path=/root/out/"$exe_name"
socket_file=/tmp/mysql_"$port_to_use".socket

killall -9 "$exe_name"
rm -rf "$data_dir"
mkdir "$data_dir"

ln -sf "$exe_orig" "$exe_path"
ln -s /root/bin_original/usr/local/mysql/lib /root/lib
/root/bin_original/usr/local/mysql/scripts/mysql_install_db --auth-root-authentication-method=normal --datadir="$data_dir"
setsid "$exe_path" --datadir="$data_dir" --log-error=/root/$RANDOM$RANDOM.mysql_log --pid-file=fuckpid.pid --disable-log-bin --socket="$socket_file" --port="$port_to_use" -uroot &
sleep 5
