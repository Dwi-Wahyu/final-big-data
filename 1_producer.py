import time
import json
import os
from datasets import load_dataset

# Folder yang akan dipantau oleh Spark
STREAM_DIR = "./streaming_data"
os.makedirs(STREAM_DIR, exist_ok=True)

print("Memuat dataset dari Hugging Face...")
ds = load_dataset("wikimedia/wikipedia", "20231101.ace", split="train")

print(f"Mulai mengirim aliran data ke direktori: {STREAM_DIR}...")

for i, row in enumerate(ds):
    file_path = os.path.join(STREAM_DIR, f"article_{i}.json")
    
    # Menulis 1 artikel sebagai 1 file JSON
    with open(file_path, "w", encoding="utf-8") as f:
        json.dump({"id": row["id"], "url": row["url"], "title": row["title"], "text": row["text"]}, f)
    
    print(f"[+] Terkirim: Artikel '{row['title']}'")
    
    # Jeda 1 detik untuk mensimulasikan data yang masuk secara real-time
    time.sleep(1)