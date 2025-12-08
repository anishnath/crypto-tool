# Parsing JSON: String to Python (json.loads)

import json

# loads = "load string" - parses JSON string to Python object

# 1. Basic JSON parsing
print("=== Basic Parsing ===")
json_string = '{"name": "Alice", "age": 30, "city": "Boston"}'
data = json.loads(json_string)

print(f"Type: {type(data)}")  # <class 'dict'>
print(f"Name: {data['name']}")
print(f"Age: {data['age']}")
print()

# 2. JSON types map to Python types
print("=== Type Conversions ===")
json_data = '''
{
    "string": "hello",
    "number": 42,
    "float": 3.14,
    "boolean_true": true,
    "boolean_false": false,
    "null_value": null,
    "array": [1, 2, 3],
    "object": {"nested": "value"}
}
'''
parsed = json.loads(json_data)
for key, value in parsed.items():
    print(f"{key}: {value} ({type(value).__name__})")
print()

# 3. Parsing JSON arrays
print("=== Parsing Arrays ===")
json_array = '[1, 2, 3, "four", true, null]'
python_list = json.loads(json_array)
print(f"Array: {python_list}")
print(f"Type: {type(python_list)}")
print()

# 4. Nested structures
print("=== Nested JSON ===")
nested_json = '''
{
    "user": {
        "name": "Bob",
        "contacts": {
            "email": "bob@example.com",
            "phone": "555-1234"
        }
    }
}
'''
data = json.loads(nested_json)
print(f"Email: {data['user']['contacts']['email']}")
