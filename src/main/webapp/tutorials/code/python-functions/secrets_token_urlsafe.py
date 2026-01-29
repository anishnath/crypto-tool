import secrets

# Generate URL-safe token
token = secrets.token_urlsafe(16)  # 16 bytes
print(f"URL-safe token: {token}")

# Longer token for session IDs
session_id = secrets.token_urlsafe(32)
print(f"Session ID: {session_id}")

# Use case: Session tokens, CSRF tokens
print(f"\nSafe for URLs: No special encoding needed!")
