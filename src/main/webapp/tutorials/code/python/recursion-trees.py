# Recursion with Tree-like Structures

# 1. Nested dictionary traversal
print("=== Traverse Nested Dict ===")
def find_value(data, key):
    """Find a key in a nested dictionary."""
    if isinstance(data, dict):
        if key in data:
            return data[key]
        for v in data.values():
            result = find_value(v, key)
            if result is not None:
                return result
    return None

config = {
    "app": {
        "name": "MyApp",
        "settings": {
            "theme": "dark",
            "language": "en"
        }
    },
    "version": "1.0"
}

print(f"Find 'theme': {find_value(config, 'theme')}")
print(f"Find 'name': {find_value(config, 'name')}")
print(f"Find 'missing': {find_value(config, 'missing')}")
print()

# 2. Flatten nested list
print("=== Flatten Nested List ===")
def flatten(nested):
    """Flatten a nested list structure."""
    result = []
    for item in nested:
        if isinstance(item, list):
            result.extend(flatten(item))
        else:
            result.append(item)
    return result

nested = [1, [2, 3], [4, [5, 6]], 7]
print(f"Original: {nested}")
print(f"Flattened: {flatten(nested)}")
print()

# 3. Count items in nested structure
print("=== Count Items ===")
def count_items(data):
    """Count all non-list items in a nested structure."""
    if not isinstance(data, list):
        return 1
    return sum(count_items(item) for item in data)

nested = [1, [2, 3], [[4, 5], 6], 7]
print(f"Structure: {nested}")
print(f"Total items: {count_items(nested)}")
print()

# 4. Directory-like structure
print("=== File System Traversal ===")
def list_files(directory, prefix=""):
    """Print all files in a directory structure."""
    for name, content in directory.items():
        if isinstance(content, dict):
            print(f"{prefix}{name}/")
            list_files(content, prefix + "  ")
        else:
            print(f"{prefix}{name}")

file_system = {
    "src": {
        "main.py": "file",
        "utils": {
            "helpers.py": "file",
            "config.py": "file"
        }
    },
    "tests": {
        "test_main.py": "file"
    },
    "README.md": "file"
}

list_files(file_system)
