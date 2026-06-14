MASTER_IP=192.168.1.93

podman rm -f spark-master namenode

podman run -d \
  --name namenode \
  --network host \
  -v "$(pwd)/hadoop/namenode:/hadoop/dfs/name" \
  -e CLUSTER_NAME=BigDataCluster \
  -e CORE_CONF_fs_defaultFS=hdfs://$MASTER_IP:9000 \
  -e HDFS_CONF_dfs_namenode_rpc_bind_host=0.0.0.0 \
  -e HDFS_CONF_dfs_namenode_http_address=0.0.0.0:9870 \
  -e HDFS_CONF_dfs_client__use_datanode_hostname=false \
  -e HDFS_CONF_dfs_datanode__use_datanode_hostname=false \
  bde2020/hadoop-namenode:2.0.0-hadoop3.2.1-java8

podman run -d \
  --name spark-master \
  --network host \
  -e SPARK_MODE=master \
  -e SPARK_LOCAL_IP=$MASTER_IP \
  -e SPARK_MASTER_HOST=$MASTER_IP \
  -v "$(pwd):/app" \
  docker.io/bitnamilegacy/spark:3.5.1