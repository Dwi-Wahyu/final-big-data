MASTER_IP=192.168.1.93
WORKER_IP=192.168.1.214  # <-- ganti sesuai IP laptop ini

podman rm -f datanode spark-worker

MASTER_IP=192.168.1.93
WORKER_IP=192.168.1.214  

podman rm -f datanode

podman run -d \
  --name datanode \
  --network host \
  -v "$(pwd)/hadoop/datanode:/hadoop/dfs/data" \
  -e CORE_CONF_fs_defaultFS=hdfs://$MASTER_IP:9000 \
  -e HDFS_CONF_dfs_datanode_hostname=$WORKER_IP \
  -e HDFS_CONF_dfs_datanode_address=0.0.0.0:9866 \
  -e HDFS_CONF_dfs_datanode_http_address=0.0.0.0:9864 \
  -e HDFS_CONF_dfs_client__use_datanode_hostname=false \
  -e HDFS_CONF_dfs_datanode__use_datanode_hostname=false \
  bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8

podman run -d \
  --name spark-worker \
  --network host \
  -e SPARK_MODE=worker \
  -e SPARK_MASTER_URL=spark://$MASTER_IP:7077 \
  -e SPARK_WORKER_HOST=$WORKER_IP \
  -e SPARK_LOCAL_IP=$WORKER_IP \
  -e SPARK_WORKER_PORT=7078 \
  docker.io/bitnamilegacy/spark:3.5.1











netsh advfirewall firewall add rule name="HDFS DataNode Transfer" dir=in action=allow protocol=TCP localport=9866
netsh advfirewall firewall add rule name="HDFS DataNode IPC" dir=in action=allow protocol=TCP localport=9867
netsh advfirewall firewall add rule name="HDFS DataNode HTTP" dir=in action=allow protocol=TCP localport=9864


MASTER_IP=192.168.1.93

podman rm -f namenode

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
  -e HDFS_CONF_dfs_namenode_datanode__registration_ip__hostname__check=false \
  bde2020/hadoop-namenode:2.0.0-hadoop3.2.1-java8