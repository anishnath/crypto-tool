# Python JSON
# JSON is a syntax for storing and exchanging data. Python has a built-in package called json.

import json

# 1. Parse JSON (JSON string to Python)
json_string = '{ "name":"John", "age":30, "city":"New York"}'
python_dict = json.loads(json_string)

print(f"Python Dict: {python_dict}")
print(f"City: {python_dict['city']}")

# 2. Convert to JSON (Python to JSON string)
x = {
  "name": "John",
  "age": 30,
  "city": "New York"
}

json_output = json.dumps(x)
print(f"JSON String: {json_output}")

# 3. Formatting JSON Output
print("\nPretty Printed JSON:")
print(json.dumps(x, indent=4, separators=(". ", " = ")))
