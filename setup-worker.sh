#!/bin/bash

# Memastikan IP Master dimasukkan saat menjalankan skrip
if [ -z "$1" ]; then
  echo "❌ Error: Anda belum memasukkan IP Master."
  echo "👉 Cara penggunaan: ./setup-worker.sh <IP_MASTER>"
  echo "💡 Contoh: bash setup-worker.sh 192.168.1.10"
  exit 1
fi

MASTER_IP=$1

echo "🔍 [1/3] Memeriksa Kompatibilitas Sistem..."
OS="$(uname -s)"
echo "💻 Sistem terdeteksi: $OS"

if ! command -v podman &> /dev/null; then
    echo "❌ ERROR: Podman tidak ditemukan!"
    echo "💡 Solusi untuk Windows/Mac: Install Podman Desktop dari podman-desktop.io"
    exit 1
fi

# Memberikan instruksi khusus jika OS bukan Linux
if [[ "$OS" == "Darwin" ]]; then
    echo "🍎 (macOS) Pastikan Podman Desktop sudah menyala (running)."
elif [[ "$OS" == *"MINGW"* || "$OS" == *"MSYS"* ]]; then
    echo "🪟 (Windows) Git Bash terdeteksi."
fi

echo "🚀 [2/3] Menghubungkan Worker ke Spark Master di IP: $MASTER_IP..."

podman rm -f spark-worker 2>/dev/null

podman run -d \
  --name spark-worker \
  -e SPARK_MODE=worker \
  -e SPARK_MASTER_URL=spark://$MASTER_IP:7077 \
  -p 8081:8081 \
  docker.io/bitnamilegacy/spark:3.5.1

echo "✅ [3/3] Spark Worker berhasil dijalankan dan terhubung!"
echo "🔍 Buka UI Worker di browser: http://localhost:8081"

# bash setup-worker.sh <IP_LAPTOP_ANDA>