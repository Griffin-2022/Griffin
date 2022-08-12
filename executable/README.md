# Griffin Executable

Griffin is based on AFLplusplus 4.00c. 
You can use Griffin as the custom mutator of AFLplusplus.
Griffin need to send meta queries to DBMS for metadata information, 
which is configured by docker environment variables.
The sample configures are the ENV parts of the Dockerfile.

# Prepare

You can run docker in RAM for best performance if you have enough memory.

```bash
systemctl stop docker
mv /var/lib/docker /var/lib/docker-backup           # backup current docker
mkdir /var/lib/docker
mount -t tmpfs -o size=100G tmpfs /var/lib/docker   # 100G memory for docker
systemctl start docker
```

## Griffin for SQLite

```bash
# execute the following commands in the docker host
DOCKER_BUILDKIT=1 docker build ./docker --target=griffin_sqlite -t griffin_sqlite
docker run --cpus=2 -m 40gb --shm-size=40gb -it --name foo griffin_sqlite
docker exec -it foo bash

# execute the following commands in the docker container
AFL_CUSTOM_MUTATOR_LIBRARY=/root/griffin_sqlite.so AFL_CUSTOM_MUTATOR_ONLY=1 /root/AFLplusplus/afl-fuzz -i /root/input-set/ -o /root/out/ -t 20 -M griffin --  /root/driver
# /root/AFLplusplus/afl-fuzz -i /root/input-set/ -o /root/out/ -t 20 -S aflpp  --  /root/driver # You can also add a new instance for parallel run.
```

## Griffin for DuckDB
```bash
# execute the following commands in the docker host
DOCKER_BUILDKIT=1 docker build ./docker --target=griffin_duckdb -t griffin_duckdb
docker run --cpus=2 -m 40gb --shm-size=40gb -it --name foo griffin_duckdb
docker exec -it foo bash

# execute the following commands in the docker container
AFL_CUSTOM_MUTATOR_LIBRARY=/root/griffin_duckdb.so AFL_CUSTOM_MUTATOR_ONLY=1 /root/AFLplusplus/afl-fuzz -i /root/input-set/ -o /root/out/ -t 20 -M griffin --  /root/driver
# /root/AFLplusplus/afl-fuzz -i /root/input-set/ -o /root/out/ -t 20 -S aflpp  --  /root/driver # You can also add a new instance for parallel run.
```

## Griffin for MySQL
```bash
# execute the following commands in the docker host
DOCKER_BUILDKIT=1 docker build ./docker --target=griffin_mysql -t griffin_mysql
docker run --cpus=2 -m 40gb --shm-size=40gb -it --name foo griffin_mysql
docker exec -it foo bash

# execute the following commands in the docker container
AFL_CUSTOM_MUTATOR_LIBRARY=/root/griffin_mysql.so AFL_CUSTOM_MUTATOR_ONLY=1 /root/AFLplusplus/afl-fuzz -i /root/input-set/ -o /root/out/ -t 20 -M griffin --  /root/driver
```

## Griffin for PostgreSQL
```bash
# execute the following commands in the docker host
DOCKER_BUILDKIT=1 docker build ./docker --target=griffin_postgres -t griffin_postgres
docker run --cpus=2 -m 40gb --shm-size=40gb -it --name foo griffin_postgres
docker exec -it foo bash

# execute the following commands in the docker container
AFL_CUSTOM_MUTATOR_LIBRARY=/root/griffin_postgres.so AFL_CUSTOM_MUTATOR_ONLY=1 /root/AFLplusplus/afl-fuzz -i /root/input-set/ -o /root/out/ -t 20 -M griffin --  /root/driver
```
