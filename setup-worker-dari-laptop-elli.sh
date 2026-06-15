MASTER_IP=192.168.1.28
WORKER_IP=192.168.1.23

podman rm -f datanode
podman run -d \
  --name datanode \
  --network host \
  -v "$(pwd)/hadoop/datanode:/hadoop/dfs/data" \
  -v "$(pwd)/hadoop/hdfs-site.xml:/etc/hadoop/hdfs-site.xml:ro" \
  -e CORE_CONF_fs_defaultFS=hdfs://$MASTER_IP:9000 \
  -e HDFS_CONF_dfs_datanode_hostname=$WORKER_IP \
  bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8

podman rm -f datanode

podman run -d \
  --name datanode \
  --network host \
  -v "$(pwd)/hadoop/datanode:/hadoop/dfs/data" \
  -v "./hadoop/hdfs-site.xml:/etc/hadoop/hdfs-site.xml:ro" \
  -e CORE_CONF_fs_defaultFS=hdfs://$MASTER_IP:9000 \
  -e HDFS_CONF_dfs_datanode_hostname=$WORKER_IP \
  bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8