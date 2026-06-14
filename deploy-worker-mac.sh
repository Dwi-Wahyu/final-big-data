MASTER_IP=192.168.1.93
WORKER_IP=$(ipconfig getifaddr en0)

podman rm -f datanode spark-worker

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


podman run -d \
  --name spark-worker \
  -p 7078:7078 \
  -p 8081:8081 \
  --add-host myhost:$WORKER_IP \
  -e SPARK_MODE=worker \
  -e SPARK_MASTER_URL=spark://$MASTER_IP:7077 \
  -e SPARK_WORKER_HOST=$WORKER_IP \
  -e SPARK_WORKER_PORT=7078 \
  --platform linux/amd64 \
  docker.io/bitnamilegacy/spark:3.5.1