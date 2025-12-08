# Common Exception Types

print("=== Common Python Exceptions ===\n")

# 1. TypeError - operation on incompatible types
print("1. TypeError - Wrong type for operation")
try:
    result = len(42)  # len() doesn't work on integers
except TypeError as e:
    print(f"   {type(e).__name__}: {e}\n")

# 2. ValueError - right type, wrong value
print("2. ValueError - Invalid value for type")
try:
    number = int("hello")  # Can't convert "hello" to int
except ValueError as e:
    print(f"   {type(e).__name__}: {e}\n")

# 3. IndexError - list index out of range
print("3. IndexError - Index out of range")
try:
    lst = [1, 2, 3]
    item = lst[10]
except IndexError as e:
    print(f"   {type(e).__name__}: {e}\n")

# 4. KeyError - dictionary key not found
print("4. KeyError - Key not found in dict")
try:
    data = {"name": "Alice"}
    value = data["age"]
except KeyError as e:
    print(f"   {type(e).__name__}: {e}\n")

# 5. AttributeError - attribute not found
print("5. AttributeError - Attribute doesn't exist")
try:
    text = "hello"
    text.append("!")  # strings don't have append
except AttributeError as e:
    print(f"   {type(e).__name__}: {e}\n")

# 6. FileNotFoundError - file doesn't exist
print("6. FileNotFoundError - File not found")
try:
    f = open("nonexistent_file.txt")
except FileNotFoundError as e:
    print(f"   {type(e).__name__}: {e}\n")

# 7. ZeroDivisionError - divide by zero
print("7. ZeroDivisionError - Division by zero")
try:
    result = 100 / 0
except ZeroDivisionError as e:
    print(f"   {type(e).__name__}: {e}\n")

# 8. ImportError - module not found
print("8. ImportError - Module not found")
try:
    import nonexistent_module
except ImportError as e:
    print(f"   {type(e).__name__}: {e}\n")

# Summary table
print("=== Quick Reference ===")
print("""
TypeError         - Wrong type (len(5), "a" + 1)
ValueError        - Bad value (int("abc"))
IndexError        - List index out of range
KeyError          - Dict key not found
AttributeError    - Object has no attribute
FileNotFoundError - File doesn't exist
ZeroDivisionError - x / 0
ImportError       - Module not found
NameError         - Variable not defined
RuntimeError      - Generic runtime error
""")
