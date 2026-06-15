netsh advfirewall firewall add rule name="HDFS DataNode Transfer" dir=in action=allow protocol=TCP localport=9866
netsh advfirewall firewall add rule name="HDFS DataNode IPC" dir=in action=allow protocol=TCP localport=9867
netsh advfirewall firewall add rule name="HDFS DataNode HTTP" dir=in action=allow protocol=TCP localport=9864
