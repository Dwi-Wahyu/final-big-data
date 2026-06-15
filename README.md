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
