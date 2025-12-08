# Dynamic Typing in Python
# Variables can change type at runtime

x = 10
print(f"x = {x}, type = {type(x).__name__}")

x = "Hello"
print(f"x = {x}, type = {type(x).__name__}")

x = 3.14
print(f"x = {x}, type = {type(x).__name__}")

x = True
print(f"x = {x}, type = {type(x).__name__}")

x = [1, 2, 3]
print(f"x = {x}, type = {type(x).__name__}")

x = None
print(f"x = {x}, type = {type(x).__name__}")
