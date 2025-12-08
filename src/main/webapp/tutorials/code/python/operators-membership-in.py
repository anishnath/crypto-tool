# The 'in' Membership Operator

# Works with lists
print("=== Lists ===")
fruits = ["apple", "banana", "cherry"]
print(f"fruits = {fruits}")
print(f"'banana' in fruits: {'banana' in fruits}")  # True
print(f"'orange' in fruits: {'orange' in fruits}")  # False

print()

# Works with strings (substring search)
print("=== Strings ===")
message = "Hello, World!"
print(f"message = '{message}'")
print(f"'World' in message: {'World' in message}")  # True
print(f"'world' in message: {'world' in message}")  # False (case-sensitive!)
print(f"'o' in message: {'o' in message}")  # True

print()

# Works with tuples
print("=== Tuples ===")
coordinates = (10, 20, 30)
print(f"coordinates = {coordinates}")
print(f"20 in coordinates: {20 in coordinates}")  # True

print()

# Works with dictionaries (checks KEYS, not values!)
print("=== Dictionaries ===")
person = {"name": "Alice", "age": 30}
print(f"person = {person}")
print(f"'name' in person: {'name' in person}")   # True (checks keys)
print(f"'Alice' in person: {'Alice' in person}") # False (Alice is a value!)
print(f"'Alice' in person.values(): {'Alice' in person.values()}")  # True

print()

# Works with sets
print("=== Sets ===")
numbers = {1, 2, 3, 4, 5}
print(f"numbers = {numbers}")
print(f"3 in numbers: {3 in numbers}")  # True
print(f"10 in numbers: {10 in numbers}") # False
