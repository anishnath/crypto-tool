# Common Try/Except Patterns

print("=== Common Patterns ===\n")

# 1. Pattern: Safe file reading
print("1. Safe File Reading:")

def read_file_safe(filename):
    try:
        with open(filename, 'r') as f:
            return f.read()
    except FileNotFoundError:
        print(f"   File not found: {filename}")
        return None
    except PermissionError:
        print(f"   Permission denied: {filename}")
        return None

content = read_file_safe("missing.txt")
print(f"   Content: {content}")
print()

# 2. Pattern: Safe type conversion
print("2. Safe Type Conversion:")

def safe_int(value, default=0):
    """Convert to int, return default on failure."""
    try:
        return int(value)
    except (ValueError, TypeError):
        return default

print(f"   safe_int('42'): {safe_int('42')}")
print(f"   safe_int('abc'): {safe_int('abc')}")
print(f"   safe_int(None): {safe_int(None)}")
print(f"   safe_int('x', -1): {safe_int('x', -1)}")
print()

# 3. Pattern: Safe dictionary access
print("3. Safe Dictionary Access:")

data = {"name": "Alice", "age": 30}

# Method 1: Try/except
def get_key_try(d, key):
    try:
        return d[key]
    except KeyError:
        return None

# Method 2: dict.get() - usually better!
def get_key_get(d, key):
    return d.get(key)

print(f"   try/except: {get_key_try(data, 'city')}")
print(f"   dict.get(): {get_key_get(data, 'city')}")
print()

# 4. Pattern: Retry on failure
print("4. Retry Pattern:")

import random

def unreliable_operation():
    if random.random() < 0.7:  # 70% failure rate
        raise ConnectionError("Network timeout")
    return "Success!"

def retry(func, max_attempts=3):
    for attempt in range(1, max_attempts + 1):
        try:
            return func()
        except ConnectionError as e:
            print(f"   Attempt {attempt} failed: {e}")
            if attempt == max_attempts:
                raise
    return None

random.seed(42)  # For reproducibility
try:
    result = retry(unreliable_operation)
    print(f"   Result: {result}")
except ConnectionError:
    print("   All attempts failed!")
print()

# 5. Pattern: Context-specific error messages
print("5. User-Friendly Messages:")

def process_config(filename):
    try:
        with open(filename) as f:
            import json
            return json.load(f)
    except FileNotFoundError:
        raise ValueError(f"Config file '{filename}' not found. "
                        "Please create it or specify a valid path.")
    except json.JSONDecodeError as e:
        raise ValueError(f"Config file '{filename}' contains invalid JSON "
                        f"at line {e.lineno}: {e.msg}")

try:
    config = process_config("config.json")
except ValueError as e:
    print(f"   {e}")
print()

# 6. Pattern: Cleanup on exception
print("6. Cleanup Pattern:")

class Database:
    def connect(self):
        print("   Connected to database")
    def close(self):
        print("   Closed database connection")
    def query(self, sql):
        if "DROP" in sql:
            raise PermissionError("DROP not allowed!")
        return [{"id": 1}]

db = Database()
try:
    db.connect()
    result = db.query("DROP TABLE users")
except PermissionError as e:
    print(f"   Error: {e}")
finally:
    db.close()  # Always cleanup!
