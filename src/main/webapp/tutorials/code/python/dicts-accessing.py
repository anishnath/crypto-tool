# Accessing Dictionary Values

person = {
    "name": "Alice",
    "age": 30,
    "city": "New York",
    "email": "alice@example.com"
}
print(f"Dictionary: {person}")
print()

# 1. Square bracket notation
print("=== Square Bracket Access ===")
print(f"person['name']: {person['name']}")
print(f"person['age']: {person['age']}")
# print(person['phone'])  # KeyError if key doesn't exist!
print()

# 2. get() method - safe access
print("=== get() Method - Safe Access ===")
print(f"person.get('name'): {person.get('name')}")
print(f"person.get('phone'): {person.get('phone')}")  # Returns None
print(f"person.get('phone', 'N/A'): {person.get('phone', 'N/A')}")  # Default value
print()

# 3. Checking if key exists
print("=== Checking Keys ===")
print(f"'name' in person: {'name' in person}")
print(f"'phone' in person: {'phone' in person}")
print(f"'phone' not in person: {'phone' not in person}")
print()

# 4. keys(), values(), items()
print("=== Keys, Values, Items ===")
print(f"Keys: {list(person.keys())}")
print(f"Values: {list(person.values())}")
print(f"Items: {list(person.items())}")
print()

# 5. Accessing nested dictionaries
print("=== Nested Dictionary Access ===")
company = {
    "name": "TechCorp",
    "address": {
        "street": "123 Main St",
        "city": "Boston",
        "zip": "02101"
    },
    "employees": ["Alice", "Bob", "Charlie"]
}
print(f"Company: {company['name']}")
print(f"City: {company['address']['city']}")
print(f"First employee: {company['employees'][0]}")
print()

# Safe nested access
print("=== Safe Nested Access ===")
# Using get() chain
zip_code = company.get('address', {}).get('zip', 'Unknown')
print(f"Zip code: {zip_code}")

# Missing key with default
country = company.get('address', {}).get('country', 'USA')
print(f"Country (default): {country}")
