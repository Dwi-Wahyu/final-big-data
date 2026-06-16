import socket
from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, split, col, length, expr
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
    .appName("WikiBigramAnalysis") \
    .config("spark.hadoop.fs.defaultFS", f"hdfs://{MASTER_IP}:9000") \
    .config("spark.sql.shuffle.partitions", "4") \
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
    .option("maxFilesPerTrigger", 1) \
    .json(f"hdfs://{MASTER_IP}:9000{HDFS_DIR}")

# Pecah teks menjadi array kata
words_df = df_stream.withColumn("words", split(col("text"), "\\s+"))

# Buat Bi-gram menggunakan expr
# zip_with menggabungkan elemen dari dua array (words[0...n-1] dan words[1...n])
bigram_df = words_df.withColumn("bigrams", expr("""
    zip_with(
        slice(words, 1, size(words) - 1),
        slice(words, 2, size(words) - 1),
        (x, y) -> concat(x, ' ', y)
    )
"""))

# Explode bi-grams, filter panjang > 7, dan hitung
final_df = bigram_df.select(explode(col("bigrams")).alias("bigram")) \
    .filter(length(col("bigram")) > 7) \
    .groupBy("bigram") \
    .count() \
    .orderBy(col("count").desc())

query = final_df.writeStream \
    .outputMode("complete") \
    .format("console") \
    .option("truncate", False) \
    .option("numRows", 20) \
    .start()

query.awaitTermination()
