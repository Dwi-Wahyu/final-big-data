#!/bin/bash

echo "🔍 [1/3] Memeriksa Kompatibilitas Sistem..."
OS="$(uname -s)"
echo "Sistem terdeteksi: $OS"

# Pengecekan apakah Podman sudah terinstal
if ! command -v podman &> /dev/null; then
    echo "❌ ERROR: Podman tidak ditemukan! Pastikan Podman (atau Podman Desktop) sudah terinstal."
    exit 1
fi

# Penyesuaian khusus berdasarkan Sistem Operasi
if [[ "$OS" == "Darwin" ]]; then
    echo "(macOS) Memastikan Podman Machine berjalan (Buka Podman Desktop jika gagal)..."
elif [[ "$OS" == *"MINGW"* || "$OS" == *"MSYS"* || "$OS" == *"CYGWIN"* ]]; then
    echo "(Windows) Terdeteksi menggunakan Git Bash / MinGW."
    echo "Sangat disarankan menggunakan WSL 2 (Ubuntu) untuk proyek Big Data."
    # Mencegah error konversi path direktori (-v) saat menggunakan Git Bash di Windows
    export MSYS_NO_PATHCONV=1 
fi

echo "🚀 [2/3] Memulai instalasi dan konfigurasi Spark Master..."

podman rm -f spark-master 2>/dev/null

CURRENT_DIR=$(pwd)

# Menjalankan Spark Master
# podman run -d \
#   --name spark-master \
#   -e SPARK_MODE=master \
#   -v "$(pwd):/app" \
#   -p 8080:8080 \
#   -p 7077:7077 \
#   docker.io/bitnamilegacy/spark:3.5.1

podman run -d \
  --name spark-master \
  --network host \
  -e SPARK_MODE=master \
  -e SPARK_LOCAL_IP=192.168.1.93 \
  -e SPARK_MASTER_HOST=192.168.1.93 \
  -v "$(pwd):/app" \
  docker.io/bitnamilegacy/spark:3.5.1

echo "✅ [3/3] Spark Master berhasil dijalankan!"
echo "🔍 Buka UI Master di browser: http://localhost:8080"