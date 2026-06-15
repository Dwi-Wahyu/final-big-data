@echo off
set MASTER_IP=%1
if "%MASTER_IP%"=="" set MASTER_IP=192.168.1.28

podman exec -it spark-master spark-submit ^
  --master spark://%MASTER_IP%:7077 ^
  --conf spark.driver.host=%MASTER_IP% ^
  --conf spark.driver.bindAddress=0.0.0.0 ^
  /app/2_spark_streaming_small.py
