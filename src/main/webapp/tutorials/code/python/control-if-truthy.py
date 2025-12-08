# Truthy and Falsy Values in Conditions

# Python evaluates these as False (falsy):
# - False
# - None
# - 0 (zero)
# - 0.0 (zero float)
# - "" (empty string)
# - [] (empty list)
# - {} (empty dict)
# - () (empty tuple)
# - set() (empty set)

# Everything else is True (truthy)

print("=== Falsy Values ===")
falsy_values = [False, None, 0, 0.0, "", [], {}, (), set()]

for value in falsy_values:
    if value:
        print(f"{repr(value):12} is truthy")
    else:
        print(f"{repr(value):12} is falsy")

print()

print("=== Truthy Values ===")
truthy_values = [True, 1, -1, "hello", [1, 2], {"a": 1}, (1,), {1}]

for value in truthy_values:
    if value:
        print(f"{repr(value):12} is truthy")
    else:
        print(f"{repr(value):12} is falsy")

print()

# Practical example: Checking if list has items
print("=== Practical Examples ===")
items = ["apple", "banana"]

# Instead of:
if len(items) > 0:
    print("List has items (using len)")

# You can simply write:
if items:
    print("List has items (using truthy check)")

print()

# Checking for None or empty string
name = ""

if not name:
    print("Name is empty or None - please provide a name")
else:
    print(f"Hello, {name}!")
