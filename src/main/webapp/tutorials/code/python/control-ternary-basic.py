# Basic Ternary Operator Syntax
# Format: value_if_true if condition else value_if_false

age = 20

# Traditional if-else (4 lines)
print("=== Traditional if-else ===")
if age >= 18:
    status = "Adult"
else:
    status = "Minor"
print(f"Age {age}: {status}")

print()

# Ternary operator (1 line!)
print("=== Ternary Operator ===")
status = "Adult" if age >= 18 else "Minor"
print(f"Age {age}: {status}")

print()

# More examples
print("=== More Examples ===")

# Determine max value
a, b = 10, 25
max_val = a if a > b else b
print(f"Max of {a} and {b}: {max_val}")

# Determine min value
min_val = a if a < b else b
print(f"Min of {a} and {b}: {min_val}")

# Check even or odd
number = 7
parity = "even" if number % 2 == 0 else "odd"
print(f"{number} is {parity}")

# Absolute value (without abs())
x = -15
absolute = x if x >= 0 else -x
print(f"Absolute value of {x}: {absolute}")
