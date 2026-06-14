# 1. Hapus NameNode yang salah
podman rm -f namenode

# 2. Jalankan NameNode baru dengan Port Mapping (Tanpa --network host)
podman run -d \
  --name namenode \
  -p 9000:9000 \
  -p 9870:9870 \
  -v "$(pwd)/hadoop/namenode:/hadoop/dfs/name" \
  -e CLUSTER_NAME=BigDataCluster \
  -e CORE_CONF_fs_defaultFS=hdfs://192.168.1.93:9000 \
  -e HDFS_CONF_dfs_namenode_rpc_bind_host=0.0.0.0 \
  bde2020/hadoop-namenode:2.0.0-hadoop3.2.1-java8