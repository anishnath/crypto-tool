import socket

# Get IP address from hostname
hostname = "www.google.com"

try:
    ip_address = socket.gethostbyname(hostname)
    print(f"Hostname: {hostname}")
    print(f"IP Address: {ip_address}")
except socket.gaierror as e:
    print(f"Could not resolve hostname: {e}")

# Resolve multiple hostnames
hostnames = ["www.google.com", "www.github.com", "www.python.org"]

print("\nDNS Lookups:")
for host in hostnames:
    try:
        ip = socket.gethostbyname(host)
        print(f"{host:20} -> {ip}")
    except:
        print(f"{host:20} -> Failed")
