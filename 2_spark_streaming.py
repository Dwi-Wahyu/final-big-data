import socket
from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, split, col, length
from pyspark.sql.types import StructType, StructField, StringType

def get_ip_address():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # Mencoba menghubungkan ke IP publik (tidak benar-benar mengirim data)
        # untuk mendapatkan local IP yang mengarah ke gateway/wifi
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
    except Exception:
        ip = "127.0.0.1"
    finally:
        s.close()
    return ip

MASTER_IP = get_ip_address()
print(f"Detected Master IP: {MASTER_IP}")

spark = SparkSession.builder \
    .appName("WikiStreamingAnalytics") \
    .config("spark.hadoop.fs.defaultFS", f"hdfs://{MASTER_IP}:9000") \
    .getOrCreate()

spark.sparkContext.setLogLevel("WARN")

schema = StructType([
    StructField("id", StringType(), True),
    StructField("url", StringType(), True),
    StructField("title", StringType(), True),
    StructField("text", StringType(), True)
])

df_stream = spark.readStream \
    .schema(schema) \
    .json(f"hdfs://{MASTER_IP}:9000/streaming_data")

words = df_stream.select(explode(split(col("text"), "\\s+")).alias("word"))
word_counts = words.filter(length(col("word")) > 4).groupBy("word").count()

query = word_counts.writeStream \
    .outputMode("complete") \
    .format("console") \
    .option("truncate", False) \
    .option("numRows", 20) \
    .start()

query.awaitTermination()