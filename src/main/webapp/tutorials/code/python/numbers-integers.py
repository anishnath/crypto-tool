# Integers in Python
# Whole numbers without decimal points

# Basic integers
age = 25
year = 2024
negative = -42
zero = 0

print("Basic integers:")
print(f"age = {age}")
print(f"year = {year}")
print(f"negative = {negative}")

# Python integers have unlimited precision!
big_number = 123456789012345678901234567890
print(f"\nBig number: {big_number}")
print(f"Type: {type(big_number)}")

# Different number bases
binary = 0b1010      # Binary (base 2) = 10
octal = 0o17         # Octal (base 8) = 15
hexadecimal = 0xFF   # Hexadecimal (base 16) = 255

print(f"\nDifferent bases:")
print(f"Binary 0b1010 = {binary}")
print(f"Octal 0o17 = {octal}")
print(f"Hex 0xFF = {hexadecimal}")

# Underscores for readability (Python 3.6+)
million = 1_000_000
credit_card = 1234_5678_9012_3456
print(f"\nWith underscores: {million:,}")
