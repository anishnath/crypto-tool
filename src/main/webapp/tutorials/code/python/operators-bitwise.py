# Bitwise Operators in Python
# Operate on bits and perform bit-by-bit operations

a = 10  # Binary: 1010
b = 4   # Binary: 0100

print(f"a = {a} (binary: {bin(a)})")
print(f"b = {b}  (binary: {bin(b)})")

# 1. Bitwise AND (&)
# Sets each bit to 1 if both bits are 1
print(f"a & b: {a & b} (binary: {bin(a & b)})")

# 2. Bitwise OR (|)
# Sets each bit to 1 if one of two bits is 1
print(f"a | b: {a | b} (binary: {bin(a | b)})")

# 3. Bitwise XOR (^)
# Sets each bit to 1 if only one of two bits is 1
print(f"a ^ b: {a ^ b} (binary: {bin(a ^ b)})")

# 4. Bitwise NOT (~)
# Inverts all the bits
print(f"~a: {~a} (binary: {bin(~a)})")

# 5. Zero fill left shift (<<)
# Shift left by pushing zeros in from the right and let the leftmost bits fall off
print(f"a << 2: {a << 2} (binary: {bin(a << 2)})")

# 6. Signed right shift (>>)
# Shift right by pushing copies of the leftmost bit in from the left, and let the rightmost bits fall off
print(f"a >> 2: {a >> 2} (binary: {bin(a >> 2)})")
