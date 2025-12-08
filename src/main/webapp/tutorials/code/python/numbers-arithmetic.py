# Arithmetic Operations in Python

a = 17
b = 5

print(f"a = {a}, b = {b}")
print("-" * 30)

# Basic operations
print(f"Addition:       a + b = {a + b}")
print(f"Subtraction:    a - b = {a - b}")
print(f"Multiplication: a * b = {a * b}")
print(f"Division:       a / b = {a / b}")      # Always returns float

# Integer division and modulo
print(f"\nInteger division: a // b = {a // b}")  # Floor division
print(f"Modulo (remainder): a % b = {a % b}")

# Power
print(f"\nPower: a ** b = {a ** b}")             # 17^5
print(f"Also: pow(a, b) = {pow(a, b)}")

# divmod - returns both quotient and remainder
quotient, remainder = divmod(a, b)
print(f"\ndivmod({a}, {b}) = ({quotient}, {remainder})")
print(f"Verification: {quotient} * {b} + {remainder} = {quotient * b + remainder}")

# Negative number division
print(f"\nNegative division:")
print(f"-17 // 5 = {-17 // 5}")   # Rounds toward negative infinity
print(f"-17 % 5 = {-17 % 5}")     # Result has same sign as divisor

# Operator precedence (PEMDAS)
print(f"\nPrecedence example:")
print(f"2 + 3 * 4 = {2 + 3 * 4}")       # 14, not 20
print(f"(2 + 3) * 4 = {(2 + 3) * 4}")   # 20
