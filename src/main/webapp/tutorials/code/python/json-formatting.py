# JSON Formatting and Pretty Printing

import json

data = {
    "name": "Alice",
    "age": 30,
    "hobbies": ["reading", "coding", "hiking"],
    "address": {
        "city": "Boston",
        "zip": "02101"
    }
}

# 1. Default output (compact)
print("=== Compact (Default) ===")
print(json.dumps(data))
print()

# 2. Pretty print with indent
print("=== Pretty Print (indent=2) ===")
print(json.dumps(data, indent=2))
print()

# 3. Different indent levels
print("=== Different Indents ===")
print("indent=4:")
print(json.dumps({"a": 1, "b": [2, 3]}, indent=4))
print()

# 4. Custom separators
print("=== Custom Separators ===")
# Default: (", ", ": ")
# Compact: (",", ":")
print("Default:")
print(json.dumps(data, indent=2))
print("\nCompact separators:")
print(json.dumps(data, separators=(",", ":")))
print()

# 5. Sort keys for consistent output
print("=== Sorted Keys ===")
unsorted = {"z": 1, "a": 2, "m": 3}
print(f"Unsorted: {json.dumps(unsorted)}")
print(f"Sorted: {json.dumps(unsorted, sort_keys=True)}")
print()

# 6. Ensure ASCII (escape non-ASCII chars)
print("=== ASCII Handling ===")
unicode_data = {"name": "caf\u00e9", "emoji": "\U0001F600"}
print(f"ensure_ascii=True: {json.dumps(unicode_data, ensure_ascii=True)}")
print(f"ensure_ascii=False: {json.dumps(unicode_data, ensure_ascii=False)}")
