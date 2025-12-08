# None in Functions
# Functions return None by default, and None for default arguments

print("=" * 50)
print("1. Functions Return None by Default")
print("=" * 50)

def greet(name):
    print(f"Hello, {name}!")
    # No return statement

result = greet("Alice")
print(f"Return value: {result}")
print(f"Type: {type(result)}")

# Empty return also returns None
def say_bye():
    print("Goodbye!")
    return

result = say_bye()
print(f"Empty return: {result}")

print("\n" + "=" * 50)
print("2. Explicit None Return")
print("=" * 50)

def find_user(user_id):
    users = {1: "Alice", 2: "Bob", 3: "Charlie"}
    return users.get(user_id)  # Returns None if not found

# Found
user = find_user(1)
print(f"find_user(1): {user}")

# Not found
user = find_user(99)
print(f"find_user(99): {user}")

# Safe to use
if user is not None:
    print(f"Found: {user}")
else:
    print("User not found")

print("\n" + "=" * 50)
print("3. None as Default Argument")
print("=" * 50)

# WRONG: Mutable default argument!
def add_item_bad(item, items=[]):  # BAD!
    items.append(item)
    return items

# This causes issues:
# print(add_item_bad("a"))  # ['a']
# print(add_item_bad("b"))  # ['a', 'b'] - Not a fresh list!

# CORRECT: Use None as default
def add_item_good(item, items=None):
    if items is None:
        items = []  # Create fresh list each time
    items.append(item)
    return items

print(add_item_good("a"))  # ['a']
print(add_item_good("b"))  # ['b'] - Fresh list!
print(add_item_good("c", ["x", "y"]))  # ['x', 'y', 'c']

print("\n" + "=" * 50)
print("4. Optional Parameters Pattern")
print("=" * 50)

def connect(host, port=None, timeout=None):
    """Connect with optional port and timeout."""
    # Use defaults if None
    if port is None:
        port = 80
    if timeout is None:
        timeout = 30

    print(f"Connecting to {host}:{port} (timeout: {timeout}s)")

connect("example.com")
connect("example.com", 443)
connect("example.com", 443, 60)
connect("example.com", timeout=10)

print("\n" + "=" * 50)
print("5. Sentinel Value Pattern")
print("=" * 50)

# When None might be a valid value, use a sentinel
_MISSING = object()  # Unique sentinel

def get_config(key, default=_MISSING):
    config = {"debug": True, "verbose": None}  # None is valid!

    if key in config:
        return config[key]
    elif default is not _MISSING:
        return default
    else:
        raise KeyError(f"Config key '{key}' not found")

print(f"debug: {get_config('debug')}")
print(f"verbose: {get_config('verbose')}")  # Returns None (valid value)
print(f"missing with default: {get_config('missing', 'default_value')}")
# get_config('missing')  # Would raise KeyError
