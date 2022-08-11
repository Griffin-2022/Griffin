#!/bin/bash                                                  

get_target_aflpp_mapsize() {
    local target="$1"

    local map_size=""

    AFL_DEBUG=1 map_size=$("$target" 2>&1 | grep AFL_MAP_SIZE | grep "[0-9]*" -o --color=never)

    if [[ -z "$map_size" ]]
    then
        map_size="65536"
    fi

    echo "$map_size"
}

create_target_driver_helper_object_file() {
    local target="$1"

    local map_size=$(get_target_aflpp_mapsize "$target")
    local c_file_content="#include <stdint.h>
uint32_t LEGO_custom_map_size = $map_size;"
    echo "$c_file_content" > /tmp/driver_helper.c
    cc /tmp/driver_helper.c -c -fPIC -o /tmp/driver_helper.o > /dev/null
    echo "/tmp/driver_helper.o"
}

target_binary="$1"

echo $(create_target_driver_helper_object_file "$target_binary")
