# Basic Assignment Operators in Python

# Simple assignment with =
name = "Alice"
age = 25
price = 19.99
is_active = True

print("=== Simple Assignment ===")
print(f"name = {name}")
print(f"age = {age}")
print(f"price = {price}")
print(f"is_active = {is_active}")

print()

# Multiple assignment on one line
x, y, z = 1, 2, 3
print("=== Multiple Assignment ===")
print(f"x, y, z = 1, 2, 3")
print(f"x = {x}, y = {y}, z = {z}")

# Assign same value to multiple variables
a = b = c = 0
print(f"a = b = c = 0")
print(f"a = {a}, b = {b}, c = {c}")

print()

# Swap values (Python makes this easy!)
print("=== Swapping Values ===")
first = "hello"
second = "world"
print(f"Before: first = {first}, second = {second}")

first, second = second, first  # Swap in one line!
print(f"After:  first = {first}, second = {second}")
