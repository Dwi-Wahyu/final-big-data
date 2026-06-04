from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, split, col, length
from pyspark.sql.types import StructType, StructField, StringType

# Inisiasi Spark Session
spark = SparkSession.builder \
    .appName("WikiStreamingAnalytics") \
    .config("spark.driver.host", "192.168.1.140") \
    .config("spark.driver.bindAddress", "0.0.0.0") \
    .getOrCreate()

spark.sparkContext.setLogLevel("WARN")

schema = StructType([
    StructField("id", StringType(), True),
    StructField("title", StringType(), True),
    StructField("text", StringType(), True)
])

# Kembali menggunakan path /app/ karena akan dieksekusi di dalam container
df_stream = spark.readStream.schema(schema).json("/app/streaming_data")

# Transformasi Data
words = df_stream.select(explode(split(col("text"), "\\s+")).alias("word"))
word_counts = words.filter(length(col("word")) > 4).groupBy("word").count()

# Tampilkan hasil
query = word_counts.writeStream \
    .outputMode("complete") \
    .format("console") \
    .start()

query.awaitTermination()