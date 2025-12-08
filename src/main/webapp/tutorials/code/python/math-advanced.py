# Advanced Math Functions

import math

# 1. Factorial and Combinations
print("=== Factorial ===")
print(f"5! = {math.factorial(5)}")  # 120
print(f"10! = {math.factorial(10)}")  # 3628800
print()

print("=== Combinations and Permutations ===")
# math.comb(n, k) - number of ways to choose k from n
print(f"C(10, 3) = {math.comb(10, 3)}")  # 120 ways
# math.perm(n, k) - permutations
print(f"P(10, 3) = {math.perm(10, 3)}")  # 720 ways
print()

# 2. Logarithms
print("=== Logarithms ===")
print(f"log(e) base e: {math.log(math.e)}")  # 1.0
print(f"log(100) base 10: {math.log10(100)}")  # 2.0
print(f"log(8) base 2: {math.log2(8)}")  # 3.0
print(f"log(81, 3): {math.log(81, 3)}")  # 4.0
print()

# 3. GCD and LCM
print("=== GCD and LCM ===")
print(f"gcd(48, 18): {math.gcd(48, 18)}")  # 6
print(f"gcd(12, 8, 24): {math.gcd(12, 8, 24)}")  # 4
print(f"lcm(12, 8): {math.lcm(12, 8)}")  # 24
print(f"lcm(4, 6, 8): {math.lcm(4, 6, 8)}")  # 24
print()

# 4. Special checks
print("=== Special Value Checks ===")
print(f"isfinite(100): {math.isfinite(100)}")
print(f"isfinite(inf): {math.isfinite(math.inf)}")
print(f"isinf(inf): {math.isinf(math.inf)}")
print(f"isnan(nan): {math.isnan(math.nan)}")
print()

# 5. Floating point comparisons
print("=== Float Comparison ===")
a = 0.1 + 0.2
b = 0.3
print(f"0.1 + 0.2 == 0.3: {a == b}")  # False!
print(f"isclose(0.1+0.2, 0.3): {math.isclose(a, b)}")  # True
