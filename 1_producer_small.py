import time
import json
import subprocess
from datasets import load_dataset

HDFS_DIR = "/streaming_data_small"

print("Membuat direktori di HDFS (jika belum ada)...")
# Perintah ini setara dengan masuk ke container dan membuat folder
subprocess.run(["podman", "exec", "-i", "namenode", "hdfs", "dfs", "-mkdir", "-p", HDFS_DIR])

print("Memuat dataset KECIL dari Hugging Face (Wikipedia ID - Indonesian)...")
ds = load_dataset("wikimedia/wikipedia", "20231101.id", split="train", streaming=True)

print(f"Memulai unduh dan DISTRIBUSI data BATCH langsung ke HDFS: {HDFS_DIR}...")
BATCH_SIZE = 100 
batch_data = []
file_index = 0
total_articles = 0
start_time = time.time()

for row in ds:
    json_str = json.dumps({"id": row["id"], "url": row["url"], "title": row["title"], "text": row["text"]})
    batch_data.append(json_str)
    total_articles += 1

    if len(batch_data) >= BATCH_SIZE:
        hdfs_file_path = f"{HDFS_DIR}/batch_{file_index}.json"
        
        # Gabungkan data batch menjadi satu string panjang di RAM
        data_string = "\n".join(batch_data) + "\n"

        # Trik Utama: Menembakkan data dari memori RAM langsung ke HDFS NameNode
        command = ["podman", "exec", "-i", "namenode", "hdfs", "dfs", "-put", "-", hdfs_file_path]
        
        process = subprocess.Popen(command, stdin=subprocess.PIPE, stderr=subprocess.PIPE)
        _, stderr_output = process.communicate(input=data_string.encode('utf-8'))

        if process.returncode != 0:
            print(f"❌ Error menyimpan batch {file_index} ke HDFS: {stderr_output.decode('utf-8')}")
        else:
            elapsed = time.time() - start_time
            rate = total_articles / elapsed
            print(f"[+] Terdistribusi ke Worker: Batch {file_index} ({BATCH_SIZE} Artikel) | Kecepatan: {rate:.0f} art/detik | Total: {total_articles}")

        batch_data = []
        file_index += 1
