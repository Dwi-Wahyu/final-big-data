@echo off
:: Usage: master\submit\windows_new_insights.bat [filename.py] [MASTER_IP]
:: Example: master\submit\windows_new_insights.bat 3_spark_insight_bigram.py 192.168.1.28

set SCRIPT_NAME=%1
set MASTER_IP=%2

if "%MASTER_IP%"=="" set MASTER_IP=192.168.1.28

if "%SCRIPT_NAME%"=="" (
    echo Usage: master\submit\windows_new_insights.bat [filename.py] [MASTER_IP]
    exit /b 1
)

echo Submitting %SCRIPT_NAME% to Spark Master at %MASTER_IP%...

podman exec -it spark-master spark-submit ^
  --master spark://%MASTER_IP%:7077 ^
  --conf spark.driver.host=%MASTER_IP% ^
  --conf spark.driver.bindAddress=0.0.0.0 ^
  --conf spark.driver.port=40001 ^
  --conf spark.blockManager.port=40002 ^
  /app/%SCRIPT_NAME%
