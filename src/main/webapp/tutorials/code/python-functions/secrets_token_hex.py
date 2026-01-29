import secrets

# Generate a secure random token (hex)
token = secrets.token_hex(16)  # 16 bytes = 32 hex characters
print(f"Secure token (hex): {token}")

# Generate another token
token2 = secrets.token_hex(32)  # 32 bytes = 64 hex characters
print(f"Longer token: {token2}")

# Use case: Password reset tokens, API keys
print(f"\nToken length: {len(token)} characters")
