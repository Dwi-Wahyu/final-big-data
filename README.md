LAST FIX

WORKER: deploy-worker.sh

MASTER: deploy-master.sh

sebisa mungkin ganti manual isi MASTER_IP atau LOCAL_IP dll

---

Cara Menjalankan (1-Liner):

Di Windows (CMD / PowerShell):

[ip master]
1 run.bat master 192.168.1.28
[ip master] [ip worker]
2 run.bat worker 192.168.1.28 192.168.1.23

Di Linux / Mac OS (Tetap sama):

[ip master]
1 bash run.sh master 192.168.1.28
[ip master] [ip worker]
2 bash run.sh worker 192.168.1.28 192.168.1.23 linux

Struktur folder tetap rapi dan sekarang sudah sepenuhnya kompatibel dengan terminal masing-masing OS.

---

Evaluasi

untuk run word count
bash master/submit/linux_mac.sh [IP_MASTER_SAAT_INI]

bash master/submit/linux_mac_small.sh [IP_MASTER_SAAT_INI]

---

### Menjalankan Insight Baru (Tugas Tambahan)

Gunakan script `submit_new_insights` untuk menjalankan analisis tambahan:

**Linux / Mac:**
```bash
# Analisis Bi-gram
bash master/submit/submit_new_insights.sh 3_spark_insight_bigram.py [IP_MASTER]

# Analisis Regex Tahun
bash master/submit/submit_new_insights.sh 4_spark_insight_regex.py [IP_MASTER]

# Streaming Socket (Jalankan producer dulu di terminal terpisah)
python3 5_producer_socket.py
bash master/submit/submit_new_insights.sh 5_spark_socket.py [IP_MASTER]
```

**Windows:**
```powershell
# Analisis Bi-gram
master\submit\windows_new_insights.bat 3_spark_insight_bigram.py [IP_MASTER]

# Analisis Regex Tahun
master\submit\windows_new_insights.bat 4_spark_insight_regex.py [IP_MASTER]

# Streaming Socket (Jalankan producer dulu di terminal terpisah)
python 5_producer_socket.py
master\submit\windows_new_insights.bat 5_spark_socket.py [IP_MASTER]
```

