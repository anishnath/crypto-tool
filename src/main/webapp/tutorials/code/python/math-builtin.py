# Built-in Math Functions (No Import Needed)

# 1. min() and max() - Find extremes
print("=== min() and max() ===")
print(f"min(5, 10, 25): {min(5, 10, 25)}")
print(f"max(5, 10, 25): {max(5, 10, 25)}")
print(f"min([3, 1, 4, 1, 5]): {min([3, 1, 4, 1, 5])}")
print(f"max('hello'): {max('hello')}")  # Largest char
print()

# 2. abs() - Absolute value
print("=== abs() ===")
print(f"abs(-7.25): {abs(-7.25)}")
print(f"abs(42): {abs(42)}")
print(f"abs(-100): {abs(-100)}")
print()

# 3. pow() - Power/exponentiation
print("=== pow() ===")
print(f"pow(2, 3): {pow(2, 3)}")       # 2^3 = 8
print(f"pow(5, 2): {pow(5, 2)}")       # 5^2 = 25
print(f"pow(2, 10): {pow(2, 10)}")     # 2^10 = 1024
print(f"pow(2, 3, 5): {pow(2, 3, 5)}") # (2^3) % 5 = 3
print()

# 4. round() - Rounding
print("=== round() ===")
print(f"round(3.14159): {round(3.14159)}")
print(f"round(3.14159, 2): {round(3.14159, 2)}")
print(f"round(3.5): {round(3.5)}")     # Banker's rounding
print(f"round(4.5): {round(4.5)}")     # Rounds to even
print()

# 5. sum() - Sum of iterable
print("=== sum() ===")
print(f"sum([1, 2, 3, 4, 5]): {sum([1, 2, 3, 4, 5])}")
print(f"sum(range(1, 11)): {sum(range(1, 11))}")  # 1-10
print(f"sum([0.1, 0.2]): {sum([0.1, 0.2])}")
