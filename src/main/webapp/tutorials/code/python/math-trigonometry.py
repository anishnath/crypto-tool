# Trigonometric Functions

import math

# Note: All trig functions use RADIANS, not degrees!

# 1. Converting between degrees and radians
print("=== Angle Conversion ===")
degrees = 90
radians = math.radians(degrees)
print(f"{degrees} degrees = {radians:.6f} radians")

rad = math.pi / 4
deg = math.degrees(rad)
print(f"{rad:.4f} radians = {deg} degrees")
print()

# 2. Basic trig functions
print("=== sin, cos, tan ===")
angle = math.pi / 6  # 30 degrees

print(f"sin(30 deg): {math.sin(angle):.6f}")  # 0.5
print(f"cos(30 deg): {math.cos(angle):.6f}")  # ~0.866
print(f"tan(30 deg): {math.tan(angle):.6f}")  # ~0.577
print()

# 3. Common angle values
print("=== Common Angles ===")
angles = [0, 30, 45, 60, 90]
for a in angles:
    rad = math.radians(a)
    print(f"{a:3d} deg: sin={math.sin(rad):6.3f}, cos={math.cos(rad):6.3f}")
print()

# 4. Inverse trig functions
print("=== Inverse Functions (arcsin, arccos, arctan) ===")
print(f"asin(0.5) = {math.degrees(math.asin(0.5)):.1f} deg")
print(f"acos(0.5) = {math.degrees(math.acos(0.5)):.1f} deg")
print(f"atan(1) = {math.degrees(math.atan(1)):.1f} deg")
print()

# 5. Hyperbolic functions
print("=== Hyperbolic Functions ===")
print(f"sinh(1): {math.sinh(1):.6f}")
print(f"cosh(1): {math.cosh(1):.6f}")
print(f"tanh(1): {math.tanh(1):.6f}")
