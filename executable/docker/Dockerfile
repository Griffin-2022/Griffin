# syntax = docker/dockerfile:1.2
FROM ubuntu:20.04 AS ubuntu_with_git

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update

RUN apt -y install git

FROM ubuntu_with_git AS aflpp_src
RUN git clone --depth 1 --branch 4.00c             \
    https://github.com/AFLplusplus/AFLplusplus.git           /root/AFLplusplus

FROM ubuntu_with_git AS mariadb_src
RUN git clone --depth 1 --branch mariadb-10.7.1 \
    https://github.com/MariaDB/server.git                    /root/mariadb

FROM ubuntu_with_git AS postgres_src
RUN git clone --depth 1 --branch REL_14_1    \
    https://github.com/postgres/postgres.git                 /root/postgres

FROM ubuntu_with_git AS sqlite_src
RUN git clone --depth 1 --branch version-3.37.0  \
    https://github.com/sqlite/sqlite.git                     /root/sqlite

FROM ubuntu_with_git AS duckdb_src
RUN git clone --depth 1 --branch v0.3.2      \
    https://github.com/duckdb/duckdb.git                     /root/duckdb

FROM ubuntu_with_git AS ubuntu_with_aflpp
RUN apt   update
RUN apt -y install clang
RUN apt -y install make
RUN apt -y install libboost-serialization-dev
RUN apt -y install libboost-regex-dev
RUN apt -y install libboost-program-options-dev
RUN apt -y install g++
RUN apt -y install wget
RUN apt -y install lsb-release software-properties-common
RUN apt -y install cmake
RUN apt -y install libsqlite3-dev
RUN apt -y install autoconf
RUN apt -y install autoconf-archive
RUN apt -y install build-essential
RUN apt -y install emacs

WORKDIR /root/
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN /root/llvm.sh 12

COPY --from=aflpp_src /root/AFLplusplus /root/AFLplusplus
# AFLplusplus
####################################
# AFLplusplus. Release version.    #
####################################
WORKDIR /root/AFLplusplus
RUN CC=clang-12 CXX=clang++-12 LLVM_CONFIG=llvm-config-12 LD=lld-12 CFLAGS="-DINTROSPECTION -DAFL_PERSISTENT_RECORD" CXXFLAGS="-DINTROSPECTION -DAFL_PERSISTENT_RECORD" make

RUN cp /root/AFLplusplus /root/AFLplusplus-griffin -r

####################################
# build afl-compiler-rt.o FOR griffin.#
####################################

WORKDIR /root/AFLplusplus-griffin/instrumentation
RUN (echo "#include <stdint.h>"; \
    echo "extern uint32_t griffin_custom_map_size;"; \
    echo "static uint32_t __afl_final_loc_fake;"; \
    cat afl-compiler-rt.o.c) \
    > afl-compiler-rt.griffin.o.c
RUN cp afl-compiler-rt.griffin.o.c afl-compiler-rt.o.c
RUN sed -i "s/++__afl_final_loc/((__afl_final_loc=griffin_custom_map_size),++__afl_final_loc_fake)/g" afl-compiler-rt.o.c

WORKDIR /root/AFLplusplus-griffin
RUN CC=clang-12 CXX=clang++-12 LLVM_CONFIG=llvm-config-12 LD=lld-12 make -f GNUmakefile.llvm afl-compiler-rt.o

COPY container_scripts/make_driver_help_object.sh  /root/make_driver_help_object.sh
RUN chmod 777 /root/make_driver_help_object.sh

WORKDIR /root

####################################
# griffin mariadb version.            #
####################################
FROM ubuntu_with_aflpp AS griffin_mariadb_baby

COPY --from=mariadb_src /root/mariadb /root/mariadb
RUN apt -y install gnutls-dev
RUN apt -y install bison
RUN apt -y install flex
RUN apt -y install psmisc
RUN apt install -y net-tools

WORKDIR /root/mariadb
WORKDIR /root/bld_original
RUN CC=clang-12 \
    CXX=clang++-12 \
    CPPFLAGS="-Wno-error=inconsistent-missing-override" \
    cmake ../mariadb -DCMAKE_BUILD_TYPE=Debug
RUN make install DESTDIR=/root/bin_original -j20

FROM griffin_mariadb_baby AS griffin_mariadb_original_asan
WORKDIR /root/bld_original_asan
RUN CC=clang-12 \
    CXX=clang++-12 \
    CPPFLAGS="-Wno-error=inconsistent-missing-override" \
    cmake ../mariadb -DWITH_ASAN=ON -DCMAKE_BUILD_TYPE=Debug
RUN make install DESTDIR=/root/bin_original_asan -j20

FROM griffin_mariadb_baby AS griffin_mariadb_aflpp_asan
WORKDIR /root/bld_aflpp_asan
RUN CC=/root/AFLplusplus/afl-clang-fast CXX=/root/AFLplusplus/afl-clang-fast++ \
    CPPFLAGS="-Wno-error=inconsistent-missing-override" \
    cmake ../mariadb -DWITH_ASAN=ON -DCMAKE_BUILD_TYPE=Debug
RUN make install DESTDIR=/root/bin_aflpp_asan -j20

FROM griffin_mariadb_baby AS griffin_mariadb

# COPY --from=griffin_mariadb_aflpp_cov     /root/bin_fast          /root/bin_fast
# COPY --from=griffin_mariadb_cov           /root/bin_coverage      /root/bin_coverage
COPY --from=griffin_mariadb_original_asan /root/bin_original_asan /root/bin_original_asan
COPY --from=griffin_mariadb_aflpp_asan    /root/bin_aflpp_asan    /root/bin_aflpp_asan

RUN cp -r /root/bin_original/usr/local/mysql        /usr/local/mysql
RUN cp    /root/bin_aflpp_asan/usr/local/mysql/bin/mysqld /usr/local/mysql/bin/mysqld

RUN apt update
RUN apt -y install tmux
RUN apt -y install emacs
RUN apt -y install fish
RUN apt -y install libmysqlclient-dev

WORKDIR /root/

COPY mariadb/driver.o                   /root/driver.o
COPY mariadb/libdriver.a                /root/libdriver.a
COPY mariadb/input-set                  /root/input-set
COPY make_driver_help_object.sh         /root/make_driver_help_object.sh
COPY mariadb/griffin_mariadb.so         /root/griffin_mariadb.so
COPY mariadb/sqlsim_client_init_mariadb.sh /root/sqlsim_client_init_mysql.sh
COPY mariadb/sqlsim_client_kill_mariadb.sh /root/sqlsim_client_kill_mysql.sh

RUN chmod 777 /root/make_driver_help_object.sh

WORKDIR /root
RUN /root/AFLplusplus-griffin/afl-clang-fast++ -I/usr/local/mysql/include/ /root/driver.o /root/libdriver.a $(/root/make_driver_help_object.sh /usr/local/mysql/bin/mysqld) -o driver      -L/usr/local/mysql/lib/ -lmysqlclient -lpthread -ldl
RUN chmod 777 /root/*.sh

ENV AFL_PRELOAD=/root/bin_original/usr/local/mysql/lib/libmysqlclient.so LD_PRELOAD=/root/bin_original/usr/local/mysql/lib/libmysqlclient.so AFL_DISABLE_TRIM=1 AFL_NO_AFFINITY=1
ENV SQLSIM_DISABLE_STARTUP_RESTART=1 SQLSIM_CONN_PORT=1000 SQLSIM_CONN_IP=127.0.0.1 SQLSIM_USERNAME=root SQLSIM_KILL_SERVER="/root/sqlsim_client_kill_mysql.sh 1000" SQLSIM_RESTART_SERVER="/root/sqlsim_client_init_mysql.sh 1000"
ENV SQLSIM_TARGET_ENV="SQLSIM_DISABLE_STARTUP_RESTART='' SQLSIM_CONN_PORT='2000' SQLSIM_CONN_IP='127.0.0.1' SQLSIM_USERNAME='root' SQLSIM_KILL_SERVER='/root/sqlsim_client_kill_mysql.sh 2000' SQLSIM_RESTART_SERVER='/root/sqlsim_client_init_mysql.sh 2000 /usr/local/mysql/bin/mysqld'"
ENV SQLSIM_TIMEOUT_MS=1000
ENV SQLSIM_DISABLE_SELF_MUTATE=1 SQLSIM_LIMIT_MERGE=1 AFL_DISABLE_TRIM=1 AFL_FAST_CAL=1 SQLSIM_WHOLE_TESTCASE=1

# mkdir /dev/shm/mariadb-data
# ln -s /dev/shm/mariadb-data/ /root/out
# AFL_CUSTOM_MUTATOR_ONLY=1 AFL_CUSTOM_MUTATOR_LIBRARY=/root/griffin_mariadb.so /root/AFLplusplus/afl-fuzz -i /root/input-set/ -o /root/out -t 100000 -- /root/driver

####################################
# griffin postgresql version.         #
####################################
# FROM ubuntu_with_aflpp AS griffin_postgres_baby

# COPY --from=postgres_src /root/postgres /root/postgres

# RUN apt update
# RUN apt -y install locales
# RUN apt -y install libz-dev
# RUN apt -y install bison
# RUN apt -y install flex
# RUN apt -y install tmux gdb fish emacs
# RUN apt -y install psmisc
# RUN apt -y install libmysqlclient-dev
# RUN apt -y install libpq-dev

# WORKDIR /root/postgres

# RUN sed "s/! nm -A -u \$< 2>\/dev\/null | grep -v __cxa_atexit | grep exit//g" -i /root/postgres/src/interfaces/libpq/Makefile
# RUN sed "s/nm -A -u \$< 2>\/dev\/null | grep -v __cxa_atexit | grep exit/(( 0 != 0 ))/g" -i /root/postgres/src/interfaces/libpq/Makefile

# WORKDIR /root/bld_original
# RUN CC=clang-12 \
#     CXX=clang++-12 \
#     /root/postgres/configure --without-readline
# RUN make -j20
# RUN make install DESTDIR=/root/bin_original -j20
# RUN make install -j20

# FROM griffin_postgres_baby AS griffin_postgres_original_asan
# WORKDIR /root/bld_original_asan
# RUN CC=clang-12 CXX=clang++-12 \
#                          CFLAGS="-fsanitize=address" \
#                          CXXFLAGS="-fsanitize=address" \
#                          LDFLAGS="-fsanitize=address" \
#                          /root/postgres/configure --without-readline
# RUN ASAN_OPTIONS=detect_leaks=0 make -j20
# RUN make install DESTDIR=/root/bin_original_asan -j20

# FROM griffin_postgres_baby AS griffin_postgres_aflpp_asan
# WORKDIR /root/bld_aflpp_asan
# RUN AFL_USE_ASAN=1 \
#     CC=/root/AFLplusplus/afl-clang-fast \
#     CXX=/root/AFLplusplus/afl-clang-fast++ \
#     /root/postgres/configure --without-readline
# RUN AFL_USE_ASAN=1 ASAN_OPTIONS=detect_leaks=0 make -j20
# RUN make install DESTDIR=/root/bin_aflpp_asan -j20

# FROM griffin_postgres_baby AS griffin_postgres_fast
# WORKDIR /root/bld_fast
# RUN AFL_LLVM_DICT2FILE=/root/llvm.dict \
#     CC=/root/AFLplusplus/afl-clang-fast \
#     CXX=/root/AFLplusplus/afl-clang-fast++ \
#     CFLAGS="-fprofile-instr-generate -fcoverage-mapping -mllvm -runtime-counter-relocation" \
#     CXXFLAGS="-fprofile-instr-generate -fcoverage-mapping -mllvm -runtime-counter-relocation" \
#     LDFLAGS="-fprofile-instr-generate -fcoverage-mapping -lpthread -pthread -lrt -Wl,--no-as-needed -ldl" \
#     /root/postgres/configure --without-readline
# RUN AFL_LLVM_DICT2FILE=/root/llvm.dict make -j20
# RUN make install DESTDIR=/root/bin_fast -j20

# FROM griffin_postgres_baby AS griffin_postgres_coverage
# WORKDIR /root/bld_coverage
# RUN CC=clang-12 \
#     CXX=clang++-12 \
#     CFLAGS="-fprofile-instr-generate -fcoverage-mapping -mllvm -runtime-counter-relocation" \
#     CXXFLAGS="-fprofile-instr-generate -fcoverage-mapping -mllvm -runtime-counter-relocation" \
#     LDFLAGS="-fprofile-instr-generate -fcoverage-mapping" \
#     /root/postgres/configure --without-readline
# RUN make install DESTDIR=/root/bin_coverage -j20

# FROM griffin_postgres_baby AS griffin_postgres

# COPY --from=griffin_postgres_coverage      /root/bin_coverage      /root/bin_coverage
# COPY --from=griffin_postgres_aflpp_asan    /root/bin_aflpp_asan    /root/bin_aflpp_asan
# COPY --from=griffin_postgres_original_asan /root/bin_original_asan /root/bin_original_asan
# COPY --from=griffin_postgres_fast          /root/bin_fast          /root/bin_fast

# RUN cp /root/bin_fast/usr/local/pgsql/bin/postgres /usr/local/pgsql/bin/postgres

# # COPY driver.cpp                    /root/target.cc
# # COPY autodriver.cpp                /root/autodriver.cpp
# # COPY client_new.hh                 /root/client_new.hh
# # COPY libclientnew.a                /root/libclientnew.a

# WORKDIR /root
# # RUN /root/AFLplusplus-griffin/afl-clang-fast++ -I/usr/local/pgsql/include/ /root/target.cc      $(/root/make_driver_help_object.sh /usr/local/pgsql/bin/postgres) -o postgres_driver -L/usr/local/pgsql/lib/ -lpq -ldl
# # RUN /root/AFLplusplus-griffin/afl-clang-fast++ -I/usr/local/pgsql/include/ /root/autodriver.cpp $(/root/make_driver_help_object.sh /usr/local/pgsql/bin/postgres) -o autodriver      -L/usr/local/pgsql/lib/ -lpq -ldl libclientnew.a -lpthread
# RUN ln -s /usr/local/pgsql/lib/libpq.so /usr/local/lib/libpq.so
# RUN apt -y install sudo
# RUN useradd postgres
# RUN chmod 777 /root
# RUN mkdir /usr/local/pgsql/data
# RUN chown postgres /usr/local/pgsql/data

# RUN chmod a+r /root
# RUN chmod a+x /root
# RUN chmod a+x /tmp
# RUN mkdir /root/out
# RUN chmod 777 /root/out
# RUN mkdir /home/postgres
# RUN chown postgres /home/postgres

# RUN locale-gen en_US.UTF-8
# RUN dpkg-reconfigure locales

# # COPY container_scripts/postgres/sqlsim_restart_pg.sh        /root/sqlsim_restart_pg.sh
# # COPY container_scripts/postgres/sqlsim_client_init_pg.sh    /root/sqlsim_client_init_pg.sh
# # COPY container_scripts/postgres/sqlsim_kill_pg.sh           /root/sqlsim_kill_pg.sh
# # COPY container_scripts/postgres/sqlsim_client_kill_pg.sh    /root/sqlsim_client_kill_pg.sh
# # COPY container_scripts/postgres/run_fuzz.sh                 /root/run_fuzz.sh
# # COPY postgres                                               /root/input-set
# # COPY container_scripts/                                     /container_scripts/

# RUN chmod 777 /root/*.sh

# COPY merge.cpp.so                                       /root/merge.so

# # COPY container_scripts                                         /container_scripts

# COPY --from=griffin_postgres_original_asan /root/bin_original_asan /root/bin_original_asan
# COPY --from=griffin_postgres_aflpp_asan    /root/bin_aflpp_asan    /root/bin_aflpp_asan

# RUN chmod 777 /root/*.sh 
# RUN chown -R postgres /container_scripts
# RUN usermod -g root postgres

FROM ubuntu_with_aflpp AS griffin_duckdb_baby

COPY --from=duckdb_src /root/duckdb /root/duckdb
RUN apt update
RUN apt -y install tmux
RUN apt -y install gdb
RUN apt -y install fish 
RUN apt -y install emacs
RUN apt -y install libpqxx-dev

FROM griffin_duckdb_baby AS griffin_duckdb_original_asan
WORKDIR /root/bld_original_asan
RUN CC=clang-12 CXX=clang++-12 \
    CFLAGS="-fsanitize=address" \
    CXXFLAGS="-fsanitize=address" \
    LDFLAGS="-fsanitize=address" \
    cmake /root/duckdb/ -DCMAKE_BUILD_TYPE=Debug -DENABLE_SANITIZER=ON -DENABLE_UBSAN=ON
RUN ASAN_OPTIONS=detect_leaks=0 make install DESTDIR=/root/bin_original_asan -j20

# Normal version.
FROM griffin_duckdb_baby AS griffin_duckdb_original
WORKDIR /root/duckdb/
WORKDIR /root/bld_original
RUN CC=clang-12 CXX=clang++-12 cmake /root/duckdb/ -DCMAKE_BUILD_TYPE=Debug -DENABLE_SANITIZER=OFF -DENABLE_UBSAN=OFF
RUN make install DESTDIR=/root/bin_original -j20

# AFL inst no-ASAN, release.
FROM griffin_duckdb_baby AS griffin_duckdb_afl
WORKDIR /root/duckdb
WORKDIR /root/bld_afl_perf
RUN CC=/root/AFLplusplus/afl-clang-fast CXX=/root/AFLplusplus/afl-clang-fast++ \
    CFLAGS="-fprofile-instr-generate -fcoverage-mapping -mllvm -runtime-counter-relocation" \
    CXXFLAGS="-fprofile-instr-generate -fcoverage-mapping -mllvm -runtime-counter-relocation" \
    LDFLAGS="-fprofile-instr-generate -fcoverage-mapping" \
    cmake /root/duckdb/ -DCMAKE_BUILD_TYPE=Debug -DENABLE_SANITIZER=OFF -DENABLE_UBSAN=OFF
RUN make install DESTDIR=/root/bin_afl_perf -j20

# AFL inst, ASAN, debug.
FROM griffin_duckdb_baby AS griffin_duckdb_afl_debug_asan
WORKDIR /root/duckdb
WORKDIR /root/bld_afl_asan_debug
RUN CC=/root/AFLplusplus/afl-clang-fast CXX=/root/AFLplusplus/afl-clang-fast++ \
    CFLAGS="-fsanitize=address" CXXFLAGS="-fsanitize=address" \
    LDFLAGS="-fsanitize=address" \
    cmake /root/duckdb/ -DCMAKE_BUILD_TYPE=Debug -DENABLE_SANITIZER=ON -DENABLE_UBSAN=ON
RUN AFL_USE_ASAN=1 make install DESTDIR=/root/bin_afl_asan_debug -j20

FROM griffin_duckdb_baby AS griffin_duckdb
COPY --from=griffin_duckdb_original /root/bld_original /root/bld_original
COPY --from=griffin_duckdb_original /root/bin_original /root/bin_original
COPY --from=griffin_duckdb_afl     /root/bld_afl_perf /root/bld_afl_perf
COPY --from=griffin_duckdb_afl     /root/bin_afl_perf /root/bin_afl_perf
COPY --from=griffin_duckdb_afl_debug_asan     /root/bld_afl_asan_debug /root/bld_afl_asan_debug
COPY --from=griffin_duckdb_afl_debug_asan     /root/bin_afl_asan_debug /root/bin_afl_asan_debug
COPY --from=griffin_duckdb_original_asan   /root/bld_original_asan /root/bld_original_asan
COPY --from=griffin_duckdb_original_asan   /root/bin_original_asan /root/bin_original_asan

COPY duckdb/driver.o                       /root/
COPY duckdb/libdriver.a                    /root/
COPY duckdb/griffin_duckdb.so              /root/griffin_duckdb.so
COPY duckdb/input-set                      /root/input-set

WORKDIR /root

RUN AFL_USE_ASAN=1 /root/AFLplusplus/afl-clang-fast++ -fprofile-instr-generate -fcoverage-mapping \
    driver.o libdriver.a -lpthread -ldl -L/root/bin_afl_asan_debug/usr/local/lib/ \
    -lduckdb_static -lduckdb_utf8proc -lduckdb_re2 -lduckdb_fmt -lduckdb_fastpforlib \
    -lduckdb_miniz -lduckdb_pg_query -lduckdb_hyperloglog \
    -g -o /root/driver

RUN chmod 777 /root/*.sh

ENV AFL_FAST_CAL=1 SQLSIM_DISABLE_TIMEOUT=1 SQLSIM_TIMEOUT_MS=100 LD_PRELOAD=/root/bin_original/usr/local/lib/libduckdb.so SQLSIM_DISABLE_SELF_MUTATE=1 SQLSIM_WHOLE_TESTCASE=1 SQLSIM_LIMIT_MERGE=1 AFL_DISABLE_TRIM=1 AFL_SHUFFLE_QUEUE=1 AFL_NO_AFFINITY=1

# AFL_CUSTOM_MUTATOR_ONLY=1 AFL_CUSTOM_MUTATOR_LIBRARY=/root/griffin_duckdb.so /root/AFLplusplus/afl-fuzz -i /root/input-set/ -o /root/out/ -t 1000 -M griffin -- /root/driver
# /root/AFLplusplus/afl-fuzz -i /root/input-set/ -o /root/out/ -t 1000 -S aflpp   -- /root/driver

FROM ubuntu_with_aflpp AS griffin_sqlite_baby

COPY --from=sqlite_src /root/sqlite /root/sqlite

RUN apt -y install tclsh
RUN apt -y install tmux gdb fish emacs
RUN apt -y install build-essential autoconf autoconf-archive
RUN apt -y install libpqxx-dev libsqlite3-dev

WORKDIR /root/sqlite

FROM griffin_sqlite_baby AS griffin_sqlite_original_asan
WORKDIR /root/bld_original_asan
RUN CC=clang-12 CXX=clang++-12 \
    CFLAGS="-fsanitize=address" LDFLAGS="-fsanitize=address" \
    /root/sqlite/configure --enable-debug
RUN ASAN_OPTIONS=detect_leaks=0 make install -j20 DESTDIR=/root/bin_original_asan

FROM griffin_sqlite_baby AS griffin_sqlite_original
WORKDIR /root/sqlite
WORKDIR /root/bld_original
RUN CC=clang-12 CXX=clang++-12 /root/sqlite/configure --enable-debug
RUN make install -j20 DESTDIR=/root/bin_original

FROM griffin_sqlite_baby AS griffin_sqlite_aflpp_asan
WORKDIR /root/bld_aflpp_asan
RUN AFL_USE_ASAN=1 \
    CC=/root/AFLplusplus/afl-clang-lto \
    CXX=/root/AFLplusplus/afl-clang-lto++ \
    /root/sqlite/configure --enable-debug
RUN ASAN_OPTIONS=detect_leaks=0 AFL_USE_ASAN=1 make install -j20 DESTDIR=/root/bin_aflpp_asan

FROM griffin_sqlite_baby AS griffin_sqlite_aflpp_no_asan
WORKDIR /root/bld_aflpp_no_asan
RUN CC=/root/AFLplusplus/afl-clang-lto \
    CXX=/root/AFLplusplus/afl-clang-lto++ \
    /root/sqlite/configure --enable-debug
RUN ASAN_OPTIONS=detect_leaks=0 make install -j20 DESTDIR=/root/bin_aflpp_no_asan

FROM griffin_sqlite_baby AS griffin_sqlite
COPY --from=griffin_sqlite_original  /root/bld_original    /root/bld_original
COPY --from=griffin_sqlite_original  /root/bin_original    /root/bin_original
COPY --from=griffin_sqlite_original_asan     /root/bin_original_asan /root/bin_original_asan
COPY --from=griffin_sqlite_aflpp_asan        /root/bld_aflpp_asan  /root/bld_aflpp_asan
COPY --from=griffin_sqlite_aflpp_asan        /root/bin_aflpp_asan  /root/bin_aflpp_asan
COPY --from=griffin_sqlite_aflpp_no_asan     /root/bld_aflpp_no_asan /root/bld_aflpp_no_asan
COPY --from=griffin_sqlite_aflpp_no_asan     /root/bin_aflpp_no_asan /root/bin_aflpp_no_asan
COPY sqlite/driver.o                         /root/driver.o
COPY sqlite/input-set                        /root/input-set
COPY sqlite/griffin_sqlite.so                /root/griffin_sqlite.so

WORKDIR /root/

RUN /root/AFLplusplus/afl-clang-lto++ -g /root/driver.o /root/bin_aflpp_no_asan/usr/local/lib/libsqlite3.a -o driver -lpthread -ldl

RUN useradd sqlite
RUN chmod a+r /root
RUN chmod a+x /root
RUN chmod a+x /tmp
RUN mkdir /root/out
RUN chmod 777 /root/
RUN chmod 777 /root/*.sh
RUN mkdir /home/sqlite
RUN chown sqlite /home/sqlite -R
RUN chmod -R a=r+x /root/
RUN apt -y install sudo

ENV SQLSIM_WHOLE_TESTCASE=1 SQLSIM_TIMEOUT_MS=100 SQLSIM_DISABLE_TIMEOUT=1 
ENV SQLSIM_DISABLE_SELF_MUTATE=1 SQLSIM_LIMIT_MERGE=1 LD_PRELOAD=/root/bin_original/usr/local/lib/libsqlite3.so 
ENV AFL_SHUFFLE_QUEUE=1 AFL_NO_AFFINITY=1

# /root/AFLplusplus/afl-fuzz -i /root/input-set/ -o /root/out/ -t 20 -S aflpp  --  /root/driver
# AFL_CUSTOM_MUTATOR_LIBRARY=/root/griffin_sqlite.so AFL_CUSTOM_MUTATOR_ONLY=1 /root/AFLplusplus/afl-fuzz -i /root/input-set/ -o /root/out/ -t 20 -M griffin --  /root/driver
