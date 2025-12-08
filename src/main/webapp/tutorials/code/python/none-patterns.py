# Common None Patterns in Python
# Useful patterns for handling None values

print("=" * 50)
print("1. Safe Navigation / Optional Chaining")
print("=" * 50)

# Problem: Accessing attributes of potentially None values
user = {"profile": {"name": "Alice", "age": 25}}

# Unsafe - crashes if any part is None
# name = user["profile"]["address"]["city"]  # KeyError!

# Safe pattern with .get()
address = user.get("profile", {}).get("address", {}).get("city")
print(f"City (safe): {address}")  # None, no crash

# For objects, use getattr with default
class Person:
    def __init__(self, name):
        self.name = name

person = None

# Unsafe: person.name would raise AttributeError
# Safe pattern:
name = getattr(person, "name", None)
print(f"Person name: {name}")

print("\n" + "=" * 50)
print("2. Null Coalescing Patterns")
print("=" * 50)

# Get first non-None value
def first_non_none(*values):
    for v in values:
        if v is not None:
            return v
    return None

name = None
default_name = "User"
fallback = "Guest"

result = first_non_none(name, default_name, fallback)
print(f"First non-None: {result}")

# Practical example
config_value = None
env_value = None
default_value = "production"

mode = first_non_none(config_value, env_value, default_value)
print(f"App mode: {mode}")

print("\n" + "=" * 50)
print("3. None-safe Operations")
print("=" * 50)

# Safe string operations
def safe_upper(s):
    return s.upper() if s is not None else None

texts = ["hello", None, "world"]
results = [safe_upper(t) for t in texts]
print(f"Safe upper: {results}")

# Safe list operations
def safe_len(collection):
    return len(collection) if collection is not None else 0

items = None
print(f"Safe length: {safe_len(items)}")

items = [1, 2, 3]
print(f"Safe length: {safe_len(items)}")

print("\n" + "=" * 50)
print("4. Filtering None Values")
print("=" * 50)

# Remove None from a list
data = [1, None, 2, None, 3, None]
clean = [x for x in data if x is not None]
print(f"Original: {data}")
print(f"Without None: {clean}")

# Using filter
clean_filter = list(filter(lambda x: x is not None, data))
print(f"Using filter: {clean_filter}")

# Filter None from dict values
config = {
    "host": "localhost",
    "port": 8080,
    "debug": None,
    "timeout": None,
    "retries": 3
}

clean_config = {k: v for k, v in config.items() if v is not None}
print(f"\nClean config: {clean_config}")

print("\n" + "=" * 50)
print("5. None-aware Comparison")
print("=" * 50)

# Sorting with None values
values = [3, None, 1, None, 2]

# This would crash: sorted(values)
# TypeError: '<' not supported between instances of 'NoneType' and 'int'

# Solution: put None at end
sorted_values = sorted(values, key=lambda x: (x is None, x))
print(f"Sorted (None at end): {sorted_values}")

# Or put None at start
sorted_values = sorted(values, key=lambda x: (x is not None, x))
print(f"Sorted (None first): {sorted_values}")

print("\n" + "=" * 50)
print("6. Database/API Pattern")
print("=" * 50)

# Simulating database lookup
def get_user_from_db(user_id):
    database = {1: {"name": "Alice"}, 2: {"name": "Bob"}}
    return database.get(user_id)  # Returns None if not found

# Pattern: check, then use
user = get_user_from_db(1)
if user is not None:
    print(f"Found user: {user['name']}")
else:
    print("User not found")

# Pattern: early return
def display_user(user_id):
    user = get_user_from_db(user_id)
    if user is None:
        return "User not found"
    return f"User: {user['name']}"

print(display_user(1))
print(display_user(99))
