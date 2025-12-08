# Nested Data Structures
# Combining lists and dictionaries to represent complex data.

# 1. List of Dictionaries (Common in JSON/APIs)
users = [
    {"id": 1, "name": "Alice", "role": "admin"},
    {"id": 2, "name": "Bob", "role": "user"},
    {"id": 3, "name": "Charlie", "role": "user"}
]

print("Users:")
for user in users:
    print(f"ID: {user['id']}, Name: {user['name']}")

# 2. Dictionary of Lists
library = {
    "fiction": ["Harry Potter", "Lord of the Rings"],
    "non_fiction": ["Sapiens", "Educated"]
}

print("\nLibrary:")
for category, books in library.items():
    print(f"{category}: {', '.join(books)}")

# 3. Dictionary of Dictionaries
employees = {
    "emp1": {"name": "John", "salary": 50000},
    "emp2": {"name": "Jane", "salary": 60000}
}

print(f"\nEmployee 1 Name: {employees['emp1']['name']}")

# 4. Accessing nested data
# Get the role of the second user
print(f"\nSecond user role: {users[1]['role']}")

# Get the first fiction book
print(f"First fiction book: {library['fiction'][0]}")
