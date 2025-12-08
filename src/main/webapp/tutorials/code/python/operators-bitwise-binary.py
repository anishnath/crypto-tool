# Understanding Binary Numbers

# Converting between decimal and binary
print("=== Decimal to Binary ===")
for num in [1, 2, 4, 8, 15, 255]:
    print(f"{num:3d} = {bin(num):>10s} = {num:08b}")

print()

# Converting binary to decimal
print("=== Binary to Decimal ===")
print(f"0b1010 = {0b1010}")
print(f"0b1111 = {0b1111}")
print(f"0b11111111 = {0b11111111}")

print()

# How binary works (positional values)
print("=== Binary Positional Values ===")
print("8-bit binary: each position represents a power of 2")
print()
print("Position:  7    6    5    4    3    2    1    0")
print("Power:    2^7  2^6  2^5  2^4  2^3  2^2  2^1  2^0")
print("Value:    128  64   32   16   8    4    2    1")
print()

# Example: 201 in binary
n = 201
print(f"Example: {n} in 8-bit binary = {n:08b}")
print(f"  = 1×128 + 1×64 + 0×32 + 0×16 + 1×8 + 0×4 + 0×2 + 1×1")
print(f"  = 128 + 64 + 8 + 1 = {128 + 64 + 8 + 1}")
