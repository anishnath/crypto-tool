
import base64

base64_message = 'SGVsbG8gV29ybGQ='
base64_bytes = base64_message.encode('ascii')

# Decode
message_bytes = base64.b64decode(base64_bytes)
message = message_bytes.decode('ascii')

print(f"Decoded Message: {message}")
