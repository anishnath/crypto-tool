import socket

# Get the hostname of the computer
hostname = socket.gethostname()
print(f"Hostname: {hostname}")

# Get local IP address
try:
    local_ip = socket.gethostbyname(hostname)
    print(f"Local IP: {local_ip}")
except Exception as e:
    print(f"Could not get IP: {e}")

# Get fully qualified domain name
fqdn = socket.getfqdn()
print(f"FQDN: {fqdn}")
