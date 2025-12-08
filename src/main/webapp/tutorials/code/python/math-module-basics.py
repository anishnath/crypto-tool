# Basic math Module Functions

import math

# 1. Square root
print("=== Square Roots ===")
print(f"math.sqrt(64): {math.sqrt(64)}")
print(f"math.sqrt(2): {math.sqrt(2):.6f}")
print(f"math.isqrt(17): {math.isqrt(17)}")  # Integer sqrt
print()

# 2. Ceiling and Floor
print("=== Ceiling and Floor ===")
print(f"math.ceil(1.4): {math.ceil(1.4)}")   # Round up
print(f"math.floor(1.9): {math.floor(1.9)}") # Round down
print(f"math.ceil(-1.4): {math.ceil(-1.4)}") # Toward zero
print(f"math.floor(-1.4): {math.floor(-1.4)}") # Away from zero
print()

# 3. Truncation
print("=== Truncation ===")
print(f"math.trunc(3.7): {math.trunc(3.7)}")
print(f"math.trunc(-3.7): {math.trunc(-3.7)}")
# trunc removes decimal, floor rounds down
print()

# 4. Constants
print("=== Math Constants ===")
print(f"math.pi: {math.pi}")
print(f"math.e: {math.e}")
print(f"math.tau: {math.tau}")  # 2*pi
print(f"math.inf: {math.inf}")
print(f"math.nan: {math.nan}")
print()

# 5. Power and Exponential
print("=== Powers ===")
print(f"math.pow(2, 3): {math.pow(2, 3)}")
print(f"math.exp(1): {math.exp(1):.6f}")  # e^1
print(f"math.exp(2): {math.exp(2):.6f}")  # e^2
