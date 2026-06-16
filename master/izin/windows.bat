@echo off
:: Menambahkan aturan firewall untuk Windows sebagai MASTER (Spark & Hadoop)
:: Jalankan sebagai Administrator

echo Menambahkan aturan firewall untuk Hadoop NameNode...
netsh advfirewall firewall add rule name="HDFS NameNode RPC" dir=in action=allow protocol=TCP localport=9000
netsh advfirewall firewall add rule name="HDFS NameNode UI" dir=in action=allow protocol=TCP localport=9870

echo Menambahkan aturan firewall untuk Spark Master...
netsh advfirewall firewall add rule name="Spark Master RPC" dir=in action=allow protocol=TCP localport=7077
netsh advfirewall firewall add rule name="Spark Master UI" dir=in action=allow protocol=TCP localport=8080

echo Menambahkan aturan firewall untuk Spark Driver (Fixed Ports)...
netsh advfirewall firewall add rule name="Spark Driver Port" dir=in action=allow protocol=TCP localport=40001
netsh advfirewall firewall add rule name="Spark BlockManager Port" dir=in action=allow protocol=TCP localport=40002
netsh advfirewall firewall add rule name="Spark Driver UI" dir=in action=allow protocol=TCP localport=4040

echo Menambahkan aturan umum untuk Subnet Lokal...
netsh advfirewall firewall add rule name="Spark Hadoop Local Subnet" dir=in action=allow protocol=TCP remoteip=192.168.1.0/24

echo Selesai.
pause
