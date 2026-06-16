import socket
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, regexp_extract, count
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
HDFS_DIR = "/streaming_data_small"

spark = SparkSession.builder \
    .appName("WikiYearAnalysis") \
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
    .json(f"hdfs://{MASTER_IP}:9000{HDFS_DIR}")

# Ekstrak tahun (18xx, 19xx, 20xx)
year_df = df_stream.withColumn("mentioned_year", regexp_extract(col("text"), r"\b(18|19|20)\d{2}\b", 0))

# Filter baris tanpa tahun, groupBy, dan hitung
final_df = year_df.filter(col("mentioned_year") != "") \
    .groupBy("mentioned_year") \
    .count() \
    .orderBy(col("count").desc())

query = final_df.writeStream \
    .outputMode("complete") \
    .format("console") \
    .option("truncate", False) \
    .option("numRows", 20) \
    .start()

query.awaitTermination()
