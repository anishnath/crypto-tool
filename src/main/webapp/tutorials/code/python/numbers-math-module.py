# Math Module in Python
import math

print("Math Constants:")
print(f"pi = {math.pi}")
print(f"e = {math.e}")
print(f"tau (2*pi) = {math.tau}")
print(f"inf = {math.inf}")

print("\n" + "=" * 40)
print("Rounding Functions:")
x = 3.7
print(f"x = {x}")
print(f"floor(x) = {math.floor(x)}")    # Round down: 3
print(f"ceil(x) = {math.ceil(x)}")      # Round up: 4
print(f"trunc(x) = {math.trunc(x)}")    # Truncate: 3
print(f"round(x) = {round(x)}")         # Built-in round: 4

print("\n" + "=" * 40)
print("Power & Logarithms:")
print(f"sqrt(16) = {math.sqrt(16)}")
print(f"pow(2, 10) = {math.pow(2, 10)}")
print(f"log(100) = {math.log(100):.4f}")       # Natural log
print(f"log10(100) = {math.log10(100)}")       # Base 10
print(f"log2(256) = {math.log2(256)}")         # Base 2

print("\n" + "=" * 40)
print("Trigonometry (radians):")
angle = math.pi / 4  # 45 degrees
print(f"sin(45°) = {math.sin(angle):.4f}")
print(f"cos(45°) = {math.cos(angle):.4f}")
print(f"tan(45°) = {math.tan(angle):.4f}")

print("\n" + "=" * 40)
print("Other useful functions:")
print(f"abs(-5) = {abs(-5)}")
print(f"factorial(5) = {math.factorial(5)}")
print(f"gcd(48, 18) = {math.gcd(48, 18)}")
print(f"isnan(float('nan')) = {math.isnan(float('nan'))}")
