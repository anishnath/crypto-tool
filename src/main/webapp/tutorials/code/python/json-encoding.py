# Converting Python to JSON (json.dumps)

import json

# dumps = "dump string" - converts Python to JSON string

# 1. Basic conversion
print("=== Basic Encoding ===")
python_dict = {
    "name": "Alice",
    "age": 30,
    "active": True
}
json_string = json.dumps(python_dict)
print(f"JSON: {json_string}")
print(f"Type: {type(json_string)}")
print()

# 2. Python types to JSON types
print("=== Type Conversions ===")
data = {
    "string": "hello",
    "integer": 42,
    "float": 3.14,
    "list": [1, 2, 3],
    "tuple": (4, 5, 6),      # Becomes array
    "dict": {"key": "value"},
    "bool_true": True,        # Becomes true
    "bool_false": False,      # Becomes false
    "none": None              # Becomes null
}
print(json.dumps(data))
print()

# 3. What CAN'T be converted?
print("=== Non-Serializable Types ===")
# These will raise TypeError:
# - sets
# - datetime objects
# - custom objects

# For custom objects, use default parameter
from datetime import datetime

def custom_encoder(obj):
    if isinstance(obj, datetime):
        return obj.isoformat()
    raise TypeError(f"Object of type {type(obj)} not serializable")

data_with_date = {"created": datetime.now()}
json_str = json.dumps(data_with_date, default=custom_encoder)
print(f"With custom encoder: {json_str}")
print()

# 4. Sort keys
print("=== Sorted Keys ===")
data = {"zebra": 1, "apple": 2, "mango": 3}
print(f"Normal: {json.dumps(data)}")
print(f"Sorted: {json.dumps(data, sort_keys=True)}")
