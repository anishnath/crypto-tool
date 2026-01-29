import secrets

# Generate secure random bytes
random_bytes = secrets.token_bytes(16)
print(f"Random bytes: {random_bytes}")
print(f"Type: {type(random_bytes)}")

# Convert to hex for display
hex_representation = random_bytes.hex()
print(f"As hex: {hex_representation}")

# Use case: Encryption keys, salts
print(f"\nLength: {len(random_bytes)} bytes")
