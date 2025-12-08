# Serializing Python to JSON - dumps() and dump()

import json

# 1. Convert Python to JSON string with dumps()
print("=== json.dumps() - To String ===")
data = {
    "name": "Alice",
    "age": 30,
    "city": "New York"
}

json_string = json.dumps(data)
print(f"Type: {type(json_string)}")
print(f"JSON: {json_string}")
print()

# 2. Python types map to JSON types
print("=== Python to JSON Type Mapping ===")
python_data = {
    "string": "hello",
    "integer": 42,
    "float": 3.14,
    "bool_true": True,
    "bool_false": False,
    "none_value": None,
    "list": [1, 2, 3],
    "dict": {"key": "value"},
    "tuple": (1, 2, 3)  # Becomes array in JSON
}

result = json.dumps(python_data)
print(result)
print()

# 3. Pretty printing with indent
print("=== Pretty Print (indent) ===")
pretty = json.dumps(data, indent=2)
print(pretty)
print()

# 4. Sorting keys
print("=== Sorted Keys ===")
unsorted = {"z": 1, "a": 2, "m": 3}
print(f"Unsorted: {json.dumps(unsorted)}")
print(f"Sorted: {json.dumps(unsorted, sort_keys=True)}")
print()

# 5. Custom separators
print("=== Custom Separators ===")
compact = json.dumps(data, separators=(",", ":"))
print(f"Compact: {compact}")

readable = json.dumps(data, separators=(", ", ": "))
print(f"Readable: {readable}")
print()

# 6. Ensure ASCII (escape non-ASCII)
print("=== ASCII Encoding ===")
unicode_data = {"greeting": "Hellö Wörld", "emoji": "👋"}

ascii_json = json.dumps(unicode_data, ensure_ascii=True)
print(f"ASCII: {ascii_json}")

unicode_json = json.dumps(unicode_data, ensure_ascii=False)
print(f"Unicode: {unicode_json}")
print()

# 7. Combining options
print("=== Combined Options ===")
formatted = json.dumps(
    data,
    indent=4,
    sort_keys=True,
    ensure_ascii=False
)
print(formatted)
