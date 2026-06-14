from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, split, col, length
from pyspark.sql.types import StructType, StructField, StringType
spark = SparkSession.builder \
    .appName("WikiStreamingAnalytics") \
    .getOrCreate()
spark.sparkContext.setLogLevel("WARN")
schema = StructType([
    StructField("id", StringType(), True),
    StructField("title", StringType(), True),
    StructField("text", StringType(), True)
])
df_stream = spark.readStream.schema(schema).json("/app/streaming_data")
words = df_stream.select(explode(split(col("text"), "\\s+")).alias("word"))
word_counts = words.filter(length(col("word")) > 4).groupBy("word").count()
query = word_counts.writeStream \
    .outputMode("complete") \
    .format("console") \
    .start()
query.awaitTermination()