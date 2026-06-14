import time
import json
import os
from datasets import load_dataset
STREAM_DIR = "/home/dwiwahyuilahi/Kuliah/Big Data/FINAL/source-code/streaming_data"
os.makedirs(STREAM_DIR, exist_ok=True)
print("Memuat dataset RAKSASA dari Hugging Face (Wikipedia EN - 70GB)...")
ds = load_dataset("wikimedia/wikipedia", "20231101.en", split="train", streaming=True)
print(f"Memulai pemboman data BATCH ke direktori: {STREAM_DIR}...")
BATCH_SIZE = 1000 
batch_data = []
file_index = 0
total_articles = 0
start_time = time.time()
for row in ds:
    json_str = json.dumps({"id": row["id"], "url": row["url"], "title": row["title"], "text": row["text"]})
    batch_data.append(json_str)
    total_articles += 1
    if len(batch_data) >= BATCH_SIZE:
        final_file_path = os.path.join(STREAM_DIR, f"batch_{file_index}.json")
        temp_file_path = os.path.join(STREAM_DIR, f".temp_batch_{file_index}.json")
        with open(temp_file_path, "w", encoding="utf-8") as f:
            f.write("\n".join(batch_data) + "\n")
        os.rename(temp_file_path, final_file_path)
        elapsed = time.time() - start_time
        rate = total_articles / elapsed
        print(f"[+] Ditembakkan: Batch {file_index} ({BATCH_SIZE} Artikel) | Kecepatan: {rate:.0f} artikel/detik | Total: {total_articles}")
        batch_data = []
        file_index += 1