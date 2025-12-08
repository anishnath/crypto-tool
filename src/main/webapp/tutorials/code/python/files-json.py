# Python JSON Files
import json

# Python dictionary
person = {
    "name": "John",
    "age": 30,
    "city": "New York",
    "hobbies": ["reading", "coding"]
}

# 1. Writing JSON to a file (Serialization)
print("--- Writing JSON ---")
with open('person.json', 'w') as f:
    json.dump(person, f, indent=4)
print("person.json created.")

# 2. Reading JSON from a file (Deserialization)
print("\n--- Reading JSON ---")
with open('person.json', 'r') as f:
    data = json.load(f)
    print(data)
    print(f"Type: {type(data)}")
    print(f"Name: {data['name']}")
