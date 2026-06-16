import socket
from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json, col
from pyspark.sql.types import StructType, StructField, StringType

def get_ip_address():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
    except Exception:
        ip = "127.0.0.1"
    finally:
        s.close()
    return ip

MASTER_IP = get_ip_address()

spark = SparkSession.builder \
    .appName("WikiSocketStreaming") \
    .getOrCreate()

spark.sparkContext.setLogLevel("WARN")

schema = StructType([
    StructField("id", StringType(), True),
    StructField("url", StringType(), True),
    StructField("title", StringType(), True),
    StructField("text", StringType(), True)
])

# Membaca stream dari network socket
df_stream = spark.readStream \
    .format("socket") \
    .option("host", MASTER_IP) \
    .option("port", 9999) \
    .load()

# Parse JSON dari kolom 'value'
parsed_df = df_stream.select(from_json(col("value"), schema).alias("data")).select("data.*")

# Contoh pemrosesan sederhana: hitung artikel per batch
article_count = parsed_df.groupBy("title").count()

query = parsed_df.writeStream \
    .outputMode("append") \
    .format("console") \
    .option("truncate", True) \
    .start()

query.awaitTermination()
