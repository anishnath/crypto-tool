# Modifying Dictionaries

person = {"name": "Alice", "age": 30, "city": "New York"}
print(f"Original: {person}")
print()

# 1. Update existing value
print("=== Updating Values ===")
person["age"] = 31
print(f"After person['age'] = 31: {person}")
print()

# 2. Add new key-value pair
print("=== Adding New Keys ===")
person["email"] = "alice@example.com"
print(f"After adding email: {person}")
print()

# 3. update() method - add/update multiple items
print("=== update() Method ===")
person.update({"age": 32, "phone": "555-1234"})
print(f"After update(): {person}")

# Can also use keyword arguments
person.update(city="Boston", country="USA")
print(f"After update(kwargs): {person}")
print()

# 4. setdefault() - add only if not exists
print("=== setdefault() ===")
person = {"name": "Alice", "age": 30}
print(f"Starting: {person}")

# Adds key because it doesn't exist
person.setdefault("city", "Unknown")
print(f"After setdefault('city', 'Unknown'): {person}")

# Doesn't change because key exists
person.setdefault("name", "Bob")
print(f"After setdefault('name', 'Bob'): {person}")
print()

# 5. Removing items
print("=== Removing Items ===")
person = {"name": "Alice", "age": 30, "city": "NYC", "temp": "delete me"}
print(f"Original: {person}")

# pop() - remove and return value
removed = person.pop("temp")
print(f"pop('temp') returned: {removed}")
print(f"After pop: {person}")

# pop() with default for missing key
missing = person.pop("phone", "Not found")
print(f"pop('phone', 'Not found'): {missing}")

# del - remove without return
del person["city"]
print(f"After del person['city']: {person}")

# popitem() - remove last item (Python 3.7+)
person = {"a": 1, "b": 2, "c": 3}
last = person.popitem()
print(f"popitem() returned: {last}")
print(f"After popitem: {person}")
print()

# 6. clear() - remove all items
print("=== clear() ===")
data = {"x": 1, "y": 2}
data.clear()
print(f"After clear(): {data}")
