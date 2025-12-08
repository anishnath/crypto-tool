# Packages - Organizing Multiple Modules

# A package is a directory containing modules
print("=== Package Structure ===")
print("""
mypackage/
    __init__.py      # Makes it a package
    module1.py       # A module
    module2.py       # Another module
    subpackage/      # Nested package
        __init__.py
        module3.py
""")

# Importing from packages
print("=== Importing from Packages ===")
print("""
# Import a module from a package
import mypackage.module1

# Import specific item from module in package
from mypackage.module1 import some_function

# Import with alias
import mypackage.module1 as m1

# Import from subpackage
from mypackage.subpackage import module3
""")

# The __init__.py file
print("=== The __init__.py File ===")
print("""
# mypackage/__init__.py

# Can be empty (just marks directory as package)

# Or can contain:
# 1. Package-level imports
from .module1 import important_function
from .module2 import AnotherClass

# 2. __all__ to control * imports
__all__ = ['module1', 'module2']

# 3. Package initialization code
print("mypackage loaded!")
""")

# Real-world package example
print("=== Real Python Package Example ===")
# Using a standard library package
import urllib.parse

url = "https://example.com/path?name=John&age=30"
parsed = urllib.parse.urlparse(url)
print(f"URL: {url}")
print(f"Scheme: {parsed.scheme}")
print(f"Host: {parsed.netloc}")
print(f"Path: {parsed.path}")
print(f"Query: {parsed.query}")
print()

# Another package example
import json

data = {"name": "Alice", "age": 25}
json_str = json.dumps(data)
print(f"JSON: {json_str}")
