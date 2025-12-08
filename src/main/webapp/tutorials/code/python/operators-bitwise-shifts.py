# Bit Shifting Operators

# Left shift (<<) - multiply by 2^n
print("=== Left Shift (<<) ===")
x = 5  # Binary: 00000101
print(f"x = {x} ({x:08b})")
print()
print(f"x << 1 = {x << 1:3d} ({x << 1:08b})  # x * 2")
print(f"x << 2 = {x << 2:3d} ({x << 2:08b})  # x * 4")
print(f"x << 3 = {x << 3:3d} ({x << 3:08b})  # x * 8")
print(f"x << 4 = {x << 4:3d} ({x << 4:08b})  # x * 16")

print()

# Right shift (>>) - divide by 2^n (floor)
print("=== Right Shift (>>) ===")
y = 100  # Binary: 01100100
print(f"y = {y} ({y:08b})")
print()
print(f"y >> 1 = {y >> 1:3d} ({y >> 1:08b})  # y // 2")
print(f"y >> 2 = {y >> 2:3d} ({y >> 2:08b})  # y // 4")
print(f"y >> 3 = {y >> 3:3d} ({y >> 3:08b})  # y // 8")
print(f"y >> 4 = {y >> 4:3d} ({y >> 4:08b})  # y // 16")

print()

# Fast multiplication and division
print("=== Fast Math with Shifts ===")
n = 7
print(f"n = {n}")
print(f"n * 2  = {n * 2}   using shift: n << 1 = {n << 1}")
print(f"n * 4  = {n * 4}   using shift: n << 2 = {n << 2}")
print(f"n * 8  = {n * 8}   using shift: n << 3 = {n << 3}")

m = 64
print(f"\nm = {m}")
print(f"m // 2  = {m // 2}   using shift: m >> 1 = {m >> 1}")
print(f"m // 4  = {m // 4}   using shift: m >> 2 = {m >> 2}")
print(f"m // 8  = {m // 8}   using shift: m >> 3 = {m >> 3}")
