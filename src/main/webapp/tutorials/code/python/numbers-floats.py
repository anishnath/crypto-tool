# Floating Point Numbers in Python
# Numbers with decimal points

# Basic floats
price = 19.99
temperature = -5.5
pi = 3.14159

print("Basic floats:")
print(f"price = {price}")
print(f"temperature = {temperature}")
print(f"pi = {pi}")

# Scientific notation
distance = 1.5e11      # 1.5 × 10^11 (distance to sun in meters)
tiny = 2.5e-10         # 2.5 × 10^-10

print(f"\nScientific notation:")
print(f"1.5e11 = {distance:,.0f}")
print(f"2.5e-10 = {tiny}")

# Float precision warning!
print("\nFloat precision issue:")
print(f"0.1 + 0.2 = {0.1 + 0.2}")  # Not exactly 0.3!
print(f"Expected: 0.3")

# For precise decimals, use the decimal module
from decimal import Decimal
d1 = Decimal('0.1')
d2 = Decimal('0.2')
print(f"\nUsing Decimal: {d1} + {d2} = {d1 + d2}")

# Special float values
print("\nSpecial values:")
print(f"float('inf') = {float('inf')}")
print(f"float('-inf') = {float('-inf')}")
print(f"float('nan') = {float('nan')}")  # Not a Number
