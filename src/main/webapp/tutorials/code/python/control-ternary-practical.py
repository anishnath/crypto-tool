# Practical Uses of Ternary Operator

# 1. Default values
print("=== Default Values ===")
username = ""
display_name = username if username else "Guest"
print(f"Display name: {display_name}")

name = "Alice"
greeting = f"Hello, {name}" if name else "Hello, stranger"
print(greeting)

print()

# 2. Conditional formatting
print("=== Conditional Formatting ===")
items_count = 1
message = f"You have {items_count} item{'s' if items_count != 1 else ''}"
print(message)

items_count = 5
message = f"You have {items_count} item{'s' if items_count != 1 else ''}"
print(message)

print()

# 3. In function arguments
print("=== In Function Arguments ===")
is_admin = True
print(f"Access level: {'Full' if is_admin else 'Limited'}")

print()

# 4. List comprehensions with ternary
print("=== In List Comprehensions ===")
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
labels = ["even" if n % 2 == 0 else "odd" for n in numbers]
print(f"Numbers: {numbers}")
print(f"Labels:  {labels}")

# Classify temperatures
temps = [18, 22, 35, 12, 28]
comfort = ["cold" if t < 20 else "hot" if t > 30 else "nice" for t in temps]
print(f"Temps:   {temps}")
print(f"Comfort: {comfort}")
