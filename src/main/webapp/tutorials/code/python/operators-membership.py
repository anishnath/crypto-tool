# Membership and Identity Operators

# --- Membership Operators ---
# Test if a sequence is presented in an object

fruits = ["apple", "banana", "cherry"]
print(f"Fruits list: {fruits}")

# 1. in
print(f"'banana' in fruits: {'banana' in fruits}")
print(f"'orange' in fruits: {'orange' in fruits}")

# 2. not in
print(f"'orange' not in fruits: {'orange' not in fruits}")

# Works with strings too
text = "Hello World"
print(f"'World' in '{text}': {'World' in text}")


# --- Identity Operators ---
# Compare the objects, not if they are equal, but if they are actually the same object, with the same memory location

x = ["apple", "banana"]
y = ["apple", "banana"]
z = x

print(f"\nx = {x}")
print(f"y = {y}")
print(f"z = x")

# 1. is
# Returns True if both variables are the same object
print(f"x is z: {x is z}")
print(f"x is y: {x is y}") # False because they are different objects in memory

# 2. is not
# Returns True if both variables are not the same object
print(f"x is not y: {x is not y}")

# Difference between == and is
print(f"\nx == y: {x == y}") # True (values are equal)
print(f"x is y: {x is y}") # False (objects are different)
