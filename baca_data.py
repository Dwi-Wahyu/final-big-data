from datasets import load_dataset

# Direktori tujuan yang sama
folder_tujuan = "/home/dwiwahyuilahi/Kuliah/Big Data/FINAL/source-code/datasets"

# Menggunakan parameter num_proc untuk mempercepat proses penyiapan dataset menggunakan multi-core CPU
pekerja = 4 

print("Mulai mengunduh Wikipedia English (~20-24 GB)...")
ds_en = load_dataset("wikimedia/wikipedia", "20231101.en", cache_dir=folder_tujuan, num_proc=pekerja)

print("Mulai mengunduh Wikipedia German (~6-7 GB)...")
ds_de = load_dataset("wikimedia/wikipedia", "20231101.de", cache_dir=folder_tujuan, num_proc=pekerja)

print("Mulai mengunduh Wikipedia French (~6-7 GB)...")
ds_fr = load_dataset("wikimedia/wikipedia", "20231101.fr", cache_dir=folder_tujuan, num_proc=pekerja)

print("Mulai mengunduh Wikipedia Russian (~6 GB)...")
ds_ru = load_dataset("wikimedia/wikipedia", "20231101.ru", cache_dir=folder_tujuan, num_proc=pekerja)

print("Mulai mengunduh Wikipedia Spanish (~5-6 GB)...")
ds_es = load_dataset("wikimedia/wikipedia", "20231101.es", cache_dir=folder_tujuan, num_proc=pekerja)

print("\n--- Selesai Mengunduh Dataset Besar ---")
# Menampilkan total baris untuk bahasa Inggris sebagai contoh
print(f"Total artikel bahasa Inggris: {len(ds_en['train'])}")
print(f"Total artikel bahasa Jerman: {len(ds_de['train'])}")
print(f"Total artikel bahasa Prancis: {len(ds_fr['train'])}")
print(f"Total artikel bahasa Rusia: {len(ds_ru['train'])}")
print(f"Total artikel bahasa Spanyol: {len(ds_es['train'])}")