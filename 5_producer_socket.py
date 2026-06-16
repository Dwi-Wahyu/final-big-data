import socket
import time
import json
from datasets import load_dataset

def get_ip_address():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
    except Exception:
        ip = "127.0.0.1"
    finally:
        s.close()
    return ip

HOST = '0.0.0.0'
PORT = 9999

print(f"Memulai Socket Server di {HOST}:{PORT}...")
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind((HOST, PORT))
server_socket.listen(1)

print("Menunggu koneksi dari Spark...")
conn, addr = server_socket.accept()
print(f"Terhubung oleh: {addr}")

print("Memuat dataset Wikipedia (ID) secara streaming...")
ds = load_dataset("wikimedia/wikipedia", "20231101.id", split="train", streaming=True)

try:
    for row in ds:
        data = {
            "id": row["id"],
            "url": row["url"],
            "title": row["title"],
            "text": row["text"]
        }
        json_data = json.dumps(data) + "\n"
        conn.sendall(json_data.encode('utf-8'))
        print(f"Sent: {row['title']}")
        time.sleep(0.1)
except Exception as e:
    print(f"Error: {e}")
finally:
    conn.close()
    server_socket.close()
