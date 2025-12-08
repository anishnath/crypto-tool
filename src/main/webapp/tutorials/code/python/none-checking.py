# Checking for None in Python
# The right way to check if a value is None

print("=" * 50)
print("1. Use 'is' to Check for None (CORRECT)")
print("=" * 50)

value = None

# The Pythonic way
if value is None:
    print("value is None ✓")

# Checking if NOT None
value = 42
if value is not None:
    print(f"value is not None, it's {value} ✓")

print("\n" + "=" * 50)
print("2. Why 'is' Instead of '=='?")
print("=" * 50)

# None is a singleton - only one None object exists
a = None
b = None
print(f"a = None, b = None")
print(f"a is b: {a is b}")     # True (same object)
print(f"a == b: {a == b}")     # Also True

# But '==' can be overridden by custom classes!
class Weird:
    def __eq__(self, other):
        return True  # Claims to equal everything!

w = Weird()
print(f"\nw == None: {w == None}")  # True (misleading!)
print(f"w is None: {w is None}")   # False (correct!)

print("\n" + "=" * 50)
print("3. Don't Use 'if x:' for None Checks!")
print("=" * 50)

# 'if x:' fails for valid "falsy" values
def process(value):
    if value:  # BAD - fails for 0, "", [], False
        return f"Processing: {value}"
    else:
        return "No value provided"

# All these are valid values, but treated as "no value"
print(process(0))          # "No value provided" - WRONG!
print(process(""))         # "No value provided" - WRONG!
print(process([]))         # "No value provided" - WRONG!

print("\nCorrect approach:")
def process_correct(value):
    if value is not None:  # GOOD - only rejects None
        return f"Processing: {value}"
    else:
        return "No value provided"

print(process_correct(0))    # "Processing: 0" ✓
print(process_correct(""))   # "Processing: " ✓
print(process_correct(None)) # "No value provided" ✓

print("\n" + "=" * 50)
print("4. Checking Multiple Values")
print("=" * 50)

# Check if any value is None
a, b, c = 1, None, 3
if None in (a, b, c):
    print("At least one value is None")

# Check if all values are not None
values = [1, 2, 3]
if all(v is not None for v in values):
    print("All values are valid (not None)")

# Find None values
data = {"name": "Alice", "age": None, "city": "NYC", "country": None}
none_keys = [k for k, v in data.items() if v is None]
print(f"\nKeys with None values: {none_keys}")

print("\n" + "=" * 50)
print("5. Common Patterns")
print("=" * 50)

# Default value if None
username = None
display_name = username if username is not None else "Anonymous"
print(f"Display name: {display_name}")

# Or using 'or' (but be careful with other falsy values!)
username = None
display_name = username or "Anonymous"  # Works for None
print(f"Using 'or': {display_name}")

# But 'or' fails with empty string!
username = ""  # Valid empty username
display_name = username or "Anonymous"  # Replaces empty string!
print(f"Empty string with 'or': {display_name}")  # "Anonymous" - might not be wanted!
