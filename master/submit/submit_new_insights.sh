#!/bin/bash
# Usage: bash master/submit/submit_new_insights.sh [filename.py] [MASTER_IP]
# Example: bash master/submit/submit_new_insights.sh 3_spark_insight_bigram.py 192.168.1.28

SCRIPT_NAME=$1
MASTER_IP=${2:-192.168.1.28}

if [ -z "$SCRIPT_NAME" ]; then
    echo "Usage: bash master/submit/submit_new_insights.sh [filename.py] [MASTER_IP]"
    exit 1
fi

echo "Submitting $SCRIPT_NAME to Spark Master at $MASTER_IP..."

podman exec -it spark-master spark-submit \
  --master spark://$MASTER_IP:7077 \
  --conf spark.driver.host=$MASTER_IP \
  --conf spark.driver.bindAddress=0.0.0.0 \
  --conf spark.driver.port=40001 \
  --conf spark.blockManager.port=40002 \
  /app/$SCRIPT_NAME
