import hashlib

text = "Hello World"
text_bytes = text.encode('utf-8')

# Calculate SHA1 (less secure, but still used)
result = hashlib.sha1(text_bytes)

print(f"Text: {text}")
print(f"SHA1 Hash: {result.hexdigest()}")
print(f"Hash length: {len(result.hexdigest())} characters")

# Note: SHA1 is deprecated for security purposes
# Use SHA256 or SHA512 for new applications
