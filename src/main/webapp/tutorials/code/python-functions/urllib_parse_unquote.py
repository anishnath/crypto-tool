from urllib.parse import unquote

# URL decode a string
encoded = "Hello%20World%21"
decoded = unquote(encoded)
print(f"Encoded: {encoded}")
print(f"Decoded: {decoded}")

# Decode email
encoded_email = "user%40example.com"
print(f"\nEncoded: {encoded_email}")
print(f"Decoded: {unquote(encoded_email)}")

# Decode query parameter
query = "name%3DJohn%26age%3D30"
print(f"\nQuery: {query}")
print(f"Decoded: {unquote(query)}")
