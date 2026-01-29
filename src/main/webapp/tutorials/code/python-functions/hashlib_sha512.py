import hashlib

text = "Hello World"
text_bytes = text.encode('utf-8')

# Calculate SHA512
result = hashlib.sha512(text_bytes)

print(f"Text: {text}")
print(f"SHA512 Hash: {result.hexdigest()}")
print(f"Hash length: {len(result.hexdigest())} characters")
