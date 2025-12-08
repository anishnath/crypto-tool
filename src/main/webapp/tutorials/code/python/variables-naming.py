# Variable Naming Rules in Python

# VALID variable names
my_name = "Alice"        # snake_case (recommended)
myName = "Bob"           # camelCase (valid but not Pythonic)
MyName = "Charlie"       # PascalCase (usually for classes)
_private = "hidden"      # leading underscore (convention for private)
name2 = "Dave"           # can contain numbers (not at start)
CONSTANT = 3.14159       # ALL_CAPS for constants

print("Valid names work fine:")
print(f"my_name = {my_name}")
print(f"_private = {_private}")
print(f"name2 = {name2}")
print(f"CONSTANT = {CONSTANT}")

# INVALID variable names (uncomment to see errors):
# 2name = "Error"        # Cannot start with number
# my-name = "Error"      # Hyphens not allowed
# my name = "Error"      # Spaces not allowed
# class = "Error"        # Reserved keyword

# Python reserved keywords (cannot use as variable names):
import keyword
print("\nPython reserved keywords:")
print(keyword.kwlist)
