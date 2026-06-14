# Membuat direktori lokal untuk menyimpan pecahan file
mkdir -p ./hadoop/datanode

# Menjalankan container HDFS DataNode
podman run -d \
  --name datanode \
  --network host \
  -v "$(pwd)/hadoop/datanode:/hadoop/dfs/data" \
  -e CORE_CONF_fs_defaultFS=hdfs://192.168.1.25:9000 \
  bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8