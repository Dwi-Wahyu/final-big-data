podman exec -it spark-master spark-submit \
  --master spark://192.168.x.x:7077 \
  /app/2_spark_streaming.py