# Buat network baru dengan subnet yang sama dengan WiFi
podman network create \
  --driver bridge \
  --subnet 192.168.1.0/24 \
  --gateway 192.168.1.1 \
  spark-net

podman machine stop
podman machine rm
podman machine init --vmtype qemu --now

# Jalankan worker dengan network tersebut
MASTER_IP=192.168.1.93
WORKER_IP=192.168.1.212

podman rm -f datanode spark-worker

podman run -d \
  --name spark-worker \
  -p 7078:7078 \
  -p 8081:8081 \
  -e SPARK_MODE=worker \
  -e SPARK_MASTER_URL=spark://$MASTER_IP:7077 \
  -e SPARK_WORKER_HOST=$WORKER_IP \
  -e SPARK_WORKER_PORT=7078 \
  -e SPARK_DAEMON_JAVA_OPTS="-Dspark.worker.host=$WORKER_IP -Dspark.local.ip=$WORKER_IP" \
  docker.io/bitnamilegacy/spark:3.5.1
  
podman run -d \
  --name datanode \
  -p 9864:9864 \
  -p 9866:9866 \
  -p 9867:9867 \
  -v "$(pwd)/hadoop/datanode:/hadoop/dfs/data" \
  -v "$(pwd)/hadoop/hdfs-site.xml:/etc/hadoop/hdfs-site.xml:ro" \
  -e CORE_CONF_fs_defaultFS=hdfs://$MASTER_IP:9000 \
  -e HDFS_CONF_dfs_datanode_hostname=$WORKER_IP \
  bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8