from urllib.parse import quote

# URL encode a string
text = "Hello World!"
encoded = quote(text)
print(f"Original: {text}")
print(f"Encoded: {encoded}")

# Encode special characters
email = "user@example.com"
print(f"\nEmail: {email}")
print(f"Encoded: {quote(email)}")

# Safe characters (don't encode)
path = "/api/users/123"
print(f"\nPath: {path}")
print(f"Encoded (safe=/): {quote(path, safe='/')}")
