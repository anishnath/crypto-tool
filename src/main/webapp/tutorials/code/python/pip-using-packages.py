# Using Installed Packages

# 1. Check Python and pip version
import sys
print("=== Environment Info ===")
print(f"Python version: {sys.version}")
print(f"Python path: {sys.executable}")
print()

# 2. List available modules
print("=== Some Standard Library Modules ===")
stdlib_modules = [
    "json", "datetime", "math", "random",
    "os", "sys", "re", "collections"
]
for mod in stdlib_modules:
    try:
        __import__(mod)
        print(f"  {mod}: Available")
    except ImportError:
        print(f"  {mod}: Not available")
print()

# 3. Popular third-party packages
print("=== Popular Third-Party Packages ===")
print("""
Data Science:
  numpy       - Numerical computing
  pandas      - Data analysis
  matplotlib  - Plotting

Web Development:
  requests    - HTTP requests
  flask       - Web framework
  django      - Full-featured framework

Utilities:
  python-dateutil - Date utilities
  pillow      - Image processing
  pyyaml      - YAML parsing
""")

# 4. Using a package (example with json, always available)
print("=== Example: Using a Package ===")
import json

data = {"name": "Alice", "score": 95}
json_str = json.dumps(data, indent=2)
print(f"JSON output:\n{json_str}")
