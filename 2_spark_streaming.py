from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, split, col, length
from pyspark.sql.types import StructType, StructField, StringType

# 1. Inisiasi Spark Session
spark = SparkSession.builder \
    .appName("WikiStreamingAnalytics") \
    .getOrCreate()

# Mengurangi log informasi yang terlalu berisik di terminal
spark.sparkContext.setLogLevel("WARN")

# 2. Definisikan Skema Data (Sesuai dengan format JSON dari Producer)
schema = StructType([
    StructField("id", StringType(), True),
    StructField("url", StringType(), True),
    StructField("title", StringType(), True),
    StructField("text", StringType(), True)
])

print("Menunggu aliran data masuk...")

# 3. Read Stream: Pantau folder "streaming_data" di dalam container (/app)
df_stream = spark.readStream \
    .schema(schema) \
    .json("/app/streaming_data")

# 4. Transformasi Data: Hitung frekuensi kata
# Pecah paragraf menjadi kata-kata (tokenization)
words = df_stream.select(
    explode(split(col("text"), "\\s+")).alias("word")
)

# Filter kata yang terlalu pendek (misal: "di", "ke") dan hitung frekuensinya
word_counts = words.filter(length(col("word")) > 3) \
    .groupBy("word") \
    .count()

# 5. Write Stream: Tampilkan hasil agregasi ke console secara real-time
query = word_counts.writeStream \
    .outputMode("complete") \
    .format("console") \
    .start()

query.awaitTermination()