# Augmented Assignment Operators
# These combine an operation with assignment

x = 10
print(f"Starting x = {x}")
print()

# Addition assignment
x += 5  # Same as: x = x + 5
print(f"x += 5  → x = {x}")

# Subtraction assignment
x -= 3  # Same as: x = x - 3
print(f"x -= 3  → x = {x}")

# Multiplication assignment
x *= 2  # Same as: x = x * 2
print(f"x *= 2  → x = {x}")

# Division assignment
x /= 4  # Same as: x = x / 4
print(f"x /= 4  → x = {x}")

print()
print("=== More Augmented Operators ===")

# Floor division assignment
y = 17
y //= 5  # Same as: y = y // 5
print(f"y = 17; y //= 5  → y = {y}")

# Modulus assignment
z = 17
z %= 5  # Same as: z = z % 5
print(f"z = 17; z %= 5   → z = {z}")

# Exponent assignment
p = 2
p **= 4  # Same as: p = p ** 4
print(f"p = 2;  p **= 4  → p = {p}")
