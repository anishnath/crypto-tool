
import hashlib

text = "Hello World"
text_bytes = text.encode('utf-8')

# Calculate SHA256
result = hashlib.sha256(text_bytes)

print(f"SHA256 Hash: {result.hexdigest()}")
