# Truthy and Falsy Values in Python
# Any value can be evaluated as a boolean

print("=" * 50)
print("FALSY VALUES (evaluate to False)")
print("=" * 50)

falsy_values = [
    False,      # The boolean False
    None,       # None/null value
    0,          # Integer zero
    0.0,        # Float zero
    0j,         # Complex zero
    "",         # Empty string
    [],         # Empty list
    (),         # Empty tuple
    {},         # Empty dictionary
    set(),      # Empty set
]

print("Value          | Type           | bool()")
print("-" * 50)
for val in falsy_values:
    val_str = repr(val)
    type_str = type(val).__name__
    print(f"{val_str:14} | {type_str:14} | {bool(val)}")

print("\n" + "=" * 50)
print("TRUTHY VALUES (evaluate to True)")
print("=" * 50)

truthy_values = [
    True,           # The boolean True
    1,              # Non-zero integer
    -1,             # Negative numbers too
    3.14,           # Non-zero float
    "hello",        # Non-empty string
    " ",            # String with just space (not empty!)
    [1, 2, 3],      # Non-empty list
    {"a": 1},       # Non-empty dictionary
    (1,),           # Non-empty tuple
]

print("Value          | Type           | bool()")
print("-" * 50)
for val in truthy_values:
    val_str = repr(val)[:14]
    type_str = type(val).__name__
    print(f"{val_str:14} | {type_str:14} | {bool(val)}")

print("\n" + "=" * 50)
print("Practical Examples")
print("=" * 50)

# Using truthy/falsy in conditions
name = ""
if name:
    print(f"Hello, {name}!")
else:
    print("Hello, stranger!")

# Checking if list has items
items = []
if items:
    print(f"Processing {len(items)} items")
else:
    print("No items to process")

# Non-empty list
items = [1, 2, 3]
if items:
    print(f"Processing {len(items)} items")

print("\n" + "=" * 50)
print("Common Patterns")
print("=" * 50)

# Default value with 'or'
user_input = ""
value = user_input or "default"
print(f"user_input='' => value = '{value}'")

user_input = "custom"
value = user_input or "default"
print(f"user_input='custom' => value = '{value}'")

# Check before access
data = {"name": "Alice"}
# Only access if key exists and has value
if data.get("name"):
    print(f"Name is: {data['name']}")

# Safe navigation with 'and'
user = None
# Only call method if user exists
username = user and user.get("name")
print(f"username = {username}")  # None (didn't crash!)
