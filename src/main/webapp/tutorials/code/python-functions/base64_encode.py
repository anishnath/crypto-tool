
import base64

message = "Hello World"
message_bytes = message.encode('ascii')

# Encode to Base64 bytes
base64_bytes = base64.b64encode(message_bytes)
print(f"Encoded Bytes: {base64_bytes}")

# Decode to String
base64_message = base64_bytes.decode('ascii')
print(f"Encoded String: {base64_message}")
