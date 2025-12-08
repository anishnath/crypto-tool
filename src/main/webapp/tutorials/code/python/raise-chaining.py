# Exception Chaining

print("=== Exception Chaining ===\n")

# 1. Implicit chaining (during handling)
print("1. Implicit chaining (__context__):")

try:
    try:
        int("not a number")
    except ValueError:
        # This exception happens DURING handling
        d = {}
        value = d["missing"]  # KeyError during ValueError handling
except KeyError as e:
    print(f"   Caught KeyError: {e}")
    print(f"   Original exception: {e.__context__}")
print()

# 2. Explicit chaining with 'from'
print("2. Explicit chaining with 'from':")

class ConfigError(Exception):
    pass

def load_config(filename):
    try:
        with open(filename) as f:
            import json
            return json.load(f)
    except FileNotFoundError as e:
        # Chain the original cause
        raise ConfigError(f"Config file '{filename}' not found") from e
    except json.JSONDecodeError as e:
        raise ConfigError(f"Invalid JSON in '{filename}'") from e

try:
    load_config("nonexistent.json")
except ConfigError as e:
    print(f"   ConfigError: {e}")
    print(f"   Caused by: {e.__cause__}")
print()

# 3. Suppress chaining with 'from None'
print("3. Suppress chaining with 'from None':")

def get_user_safe(user_id):
    try:
        # Simulate internal lookup error
        raise KeyError(f"user_{user_id}")
    except KeyError:
        # Hide internal implementation detail
        raise ValueError(f"User {user_id} not found") from None

try:
    get_user_safe(42)
except ValueError as e:
    print(f"   ValueError: {e}")
    print(f"   __cause__: {e.__cause__}")  # None - suppressed
    print(f"   __context__: {e.__context__}")  # Still set internally
    print(f"   __suppress_context__: {e.__suppress_context__}")  # True
print()

# 4. Practical example: API wrapper
print("4. Practical: API error wrapping:")

import json

class APIError(Exception):
    """Public API error."""
    def __init__(self, message, status_code=500):
        super().__init__(message)
        self.status_code = status_code

def fetch_user_data(user_id):
    """Simulate fetching user data."""
    # Simulate different internal errors
    if user_id < 0:
        raise ValueError("Internal: negative ID")
    if user_id == 0:
        raise KeyError("Internal: user not in cache")
    if user_id == 999:
        raise ConnectionError("Internal: database timeout")
    return {"id": user_id, "name": "Alice"}

def get_user(user_id):
    """Public API - wraps internal errors."""
    try:
        return fetch_user_data(user_id)
    except ValueError as e:
        raise APIError("Invalid user ID", 400) from e
    except KeyError as e:
        raise APIError("User not found", 404) from e
    except ConnectionError as e:
        raise APIError("Service unavailable", 503) from e

test_ids = [-1, 0, 999, 42]
for uid in test_ids:
    try:
        user = get_user(uid)
        print(f"   User {uid}: {user}")
    except APIError as e:
        print(f"   User {uid}: [{e.status_code}] {e}")
        if e.__cause__:
            print(f"             (internal: {e.__cause__})")
print()

# 5. __context__ vs __cause__
print("5. __context__ vs __cause__:")
print("""
__context__ (implicit chaining):
  - Set automatically when exception raised during handling
  - Shows what was being handled when new error occurred

__cause__ (explicit chaining with 'from'):
  - Set explicitly with 'raise X from Y'
  - Clearly indicates Y caused X

from None:
  - Suppresses the chain in traceback
  - Use to hide implementation details
""")

# 6. Complete traceback example
print("6. How chaining appears in traceback:")
print("""
Without chaining:
  Traceback...
  ConfigError: Config file not found

With 'from e':
  Traceback...
  FileNotFoundError: [Errno 2] No such file

  The above exception was the direct cause of:

  Traceback...
  ConfigError: Config file not found

With implicit (during handling):
  Traceback...
  ValueError: conversion failed

  During handling, another exception occurred:

  Traceback...
  KeyError: 'missing'
""")
