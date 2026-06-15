@echo off
if "%MASTER_IP%"=="" set MASTER_IP=192.168.1.28
if "%WORKER_IP%"=="" set WORKER_IP=192.168.1.23

podman rm -f datanode spark-worker
timeout /t 2 /nobreak > nul

podman run -d ^
  --name datanode ^
  --network host ^
  -v "%cd%/hadoop/datanode:/hadoop/dfs/data" ^
  -e CORE_CONF_fs_defaultFS=hdfs://%MASTER_IP%:9000 ^
  -e HDFS_CONF_dfs_datanode_hostname=%WORKER_IP% ^
  -e HDFS_CONF_dfs_datanode_use_datanode_hostname=false ^
  -e HDFS_CONF_dfs_client_use_datanode_hostname=false ^
  bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8

podman run -d ^
  --name spark-worker ^
  --network host ^
  -e SPARK_MODE=worker ^
  -e SPARK_MASTER_URL=spark://%MASTER_IP%:7077 ^
  -e SPARK_WORKER_PORT=7078 ^
  -e SPARK_WORKER_HOST=%WORKER_IP% ^
  -e SPARK_LOCAL_IP=%WORKER_IP% ^
  docker.io/bitnamilegacy/spark:3.5.1
