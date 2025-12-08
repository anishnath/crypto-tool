# Basic Raise Statement

print("=== Basic Raise ===\n")

# 1. Raise with message
print("1. Raise with message:")
try:
    age = -5
    if age < 0:
        raise ValueError("Age cannot be negative")
except ValueError as e:
    print(f"   Caught: {e}")
print()

# 2. Raise different exception types
print("2. Different exception types:")

def validate_input(value):
    if value is None:
        raise TypeError("Value cannot be None")
    if not isinstance(value, (int, float)):
        raise TypeError(f"Expected number, got {type(value).__name__}")
    if value < 0:
        raise ValueError("Value must be non-negative")
    if value > 100:
        raise ValueError("Value must be <= 100")
    return value

test_values = [None, "hello", -5, 150, 50]
for val in test_values:
    try:
        result = validate_input(val)
        print(f"   {val!r:10} -> Valid: {result}")
    except (TypeError, ValueError) as e:
        print(f"   {val!r:10} -> Error: {e}")
print()

# 3. Raise without message (not recommended)
print("3. Raise with minimal info:")
try:
    raise RuntimeError  # No message - less helpful
except RuntimeError as e:
    print(f"   Caught RuntimeError: '{e}'")
    print(f"   args: {e.args}")
print()

# 4. Raise with multiple arguments
print("4. Exception with multiple args:")
try:
    raise ValueError("Invalid value", 42, "expected positive")
except ValueError as e:
    print(f"   Message: {e}")
    print(f"   All args: {e.args}")
print()

# 5. Common patterns for validation
print("5. Validation patterns:")

def process_config(config):
    """Validate and process configuration."""
    if not isinstance(config, dict):
        raise TypeError(f"Config must be dict, got {type(config).__name__}")

    required = ['host', 'port', 'timeout']
    missing = [key for key in required if key not in config]
    if missing:
        raise KeyError(f"Missing required config keys: {missing}")

    if not isinstance(config['port'], int):
        raise TypeError("Port must be integer")
    if not 1 <= config['port'] <= 65535:
        raise ValueError(f"Port {config['port']} out of range (1-65535)")

    return config

# Test configurations
configs = [
    "not a dict",
    {"host": "localhost"},
    {"host": "localhost", "port": "80", "timeout": 30},
    {"host": "localhost", "port": 99999, "timeout": 30},
    {"host": "localhost", "port": 8080, "timeout": 30},
]

for config in configs:
    try:
        result = process_config(config)
        print(f"   Valid config: {result}")
    except (TypeError, KeyError, ValueError) as e:
        print(f"   Invalid: {type(e).__name__}: {e}")
