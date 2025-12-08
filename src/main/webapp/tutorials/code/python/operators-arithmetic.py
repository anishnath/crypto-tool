# Arithmetic Operators in Python
# These operators are used to perform mathematical operations

# 1. Addition (+)
a = 10
b = 5
print(f"Addition: {a} + {b} = {a + b}")

# 2. Subtraction (-)
print(f"Subtraction: {a} - {b} = {a - b}")

# 3. Multiplication (*)
print(f"Multiplication: {a} * {b} = {a * b}")

# 4. Division (/) - Always returns a float
print(f"Division: {a} / {b} = {a / b}")

# 5. Floor Division (//) - Returns the integer part of the quotient
c = 17
d = 5
print(f"Floor Division: {c} // {d} = {c // d}")

# 6. Modulus (%) - Returns the remainder
print(f"Modulus: {c} % {d} = {c % d}")

# 7. Exponentiation (**) - Power
base = 2
exponent = 3
print(f"Exponentiation: {base} ** {exponent} = {base ** exponent}")

# Order of Operations (PEMDAS)
result = 5 + 2 * 3 ** 2
print(f"Order of Operations (5 + 2 * 3 ** 2): {result}")
# Explanation: 3**2=9, then 2*9=18, then 5+18=23
