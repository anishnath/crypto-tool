
import hashlib

text = "Hello World"
# Encode string to bytes first
text_bytes = text.encode('utf-8')

# Calculate MD5
result = hashlib.md5(text_bytes)

# Print keys (hex digest)
print(f"MD5 Hash: {result.hexdigest()}")
