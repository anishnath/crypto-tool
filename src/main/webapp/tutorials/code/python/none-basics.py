# None Basics in Python
# None represents the absence of a value

print("=" * 50)
print("1. What is None?")
print("=" * 50)

# None is a singleton - there's only one None object
x = None
y = None

print(f"x = {x}")
print(f"y = {y}")
print(f"type(None) = {type(None)}")

# x and y refer to the same object
print(f"\nx is y: {x is y}")  # True!

print("\n" + "=" * 50)
print("2. None is Falsy")
print("=" * 50)

# None evaluates to False in boolean context
if None:
    print("This won't print")
else:
    print("None is falsy")

# Check truthiness
print(f"bool(None) = {bool(None)}")

# But None is NOT the same as False!
print(f"None == False: {None == False}")  # False
print(f"None == 0: {None == 0}")          # False
print(f"None == '': {None == ''}")        # False

print("\n" + "=" * 50)
print("3. None vs Other 'Empty' Values")
print("=" * 50)

# These are all different!
values = [None, False, 0, 0.0, "", [], {}]

print("Value".ljust(15) + "Type".ljust(15) + "is None")
print("-" * 45)
for v in values:
    display = repr(v)
    type_name = type(v).__name__
    is_none = v is None
    print(f"{display:15}{type_name:15}{is_none}")

print("\n" + "=" * 50)
print("4. Common Use Cases")
print("=" * 50)

# Uninitialized value
result = None
print(f"Uninitialized result: {result}")

# After computation
if True:  # Simulate some condition
    result = 42
print(f"After computation: {result}")

# Clearing a variable
data = [1, 2, 3]
print(f"\ndata before: {data}")
data = None  # Release the list
print(f"data after: {data}")

# Placeholder in data structures
config = {
    "name": "MyApp",
    "debug": True,
    "api_key": None,  # Not set yet
    "timeout": None   # Will use default
}
print(f"\nConfig: {config}")
