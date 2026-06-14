# Membuat direktori relatif dari posisi saat ini
mkdir -p ./hadoop/namenode

# Menjalankan container NameNode dengan path relatif $(pwd)
podman run -d \
  --name namenode \
  --network host \
  -v "$(pwd)/hadoop/namenode:/hadoop/dfs/name" \
  -e CLUSTER_NAME=BigDataCluster \
  -e CORE_CONF_fs_defaultFS=hdfs://192.168.1.25:9000 \
  bde2020/hadoop-namenode:2.0.0-hadoop3.2.1-java8