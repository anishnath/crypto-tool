# Parsing JSON - loads() and load()

import json

# 1. Parse JSON string with loads()
print("=== json.loads() - Parse String ===")
json_string = '{"name": "Alice", "age": 30, "city": "New York"}'
data = json.loads(json_string)

print(f"Type: {type(data)}")
print(f"Data: {data}")
print(f"Name: {data['name']}")
print(f"Age: {data['age']}")
print()

# 2. JSON types map to Python types
print("=== JSON to Python Type Mapping ===")
json_types = '''
{
    "string": "hello",
    "number_int": 42,
    "number_float": 3.14,
    "boolean_true": true,
    "boolean_false": false,
    "null_value": null,
    "array": [1, 2, 3],
    "object": {"key": "value"}
}
'''

parsed = json.loads(json_types)
for key, value in parsed.items():
    print(f"  {key}: {value!r} ({type(value).__name__})")
print()

# 3. Nested JSON structures
print("=== Nested JSON ===")
nested_json = '''
{
    "user": {
        "name": "Bob",
        "profile": {
            "bio": "Developer",
            "skills": ["Python", "JavaScript", "SQL"]
        }
    }
}
'''

nested = json.loads(nested_json)
print(f"User: {nested['user']['name']}")
print(f"Bio: {nested['user']['profile']['bio']}")
print(f"Skills: {nested['user']['profile']['skills']}")
print(f"First skill: {nested['user']['profile']['skills'][0]}")
print()

# 4. JSON arrays
print("=== JSON Arrays ===")
json_array = '[{"id": 1, "name": "Alice"}, {"id": 2, "name": "Bob"}]'
users = json.loads(json_array)

print(f"Type: {type(users)}")
for user in users:
    print(f"  User {user['id']}: {user['name']}")
print()

# 5. Handling parse errors
print("=== Error Handling ===")
invalid_json = '{"name": "Alice", age: 30}'  # Missing quotes around 'age'

try:
    data = json.loads(invalid_json)
except json.JSONDecodeError as e:
    print(f"JSON Error: {e.msg}")
    print(f"Position: {e.pos}")
    print(f"Line: {e.lineno}, Column: {e.colno}")
