# Basic Bitwise Operators

a = 12  # Binary: 1100
b = 10  # Binary: 1010

# Show binary representations
print("=== Binary Representations ===")
print(f"a = {a:2d}  →  binary: {bin(a):>6s}  →  {a:04b}")
print(f"b = {b:2d}  →  binary: {bin(b):>6s}  →  {b:04b}")
print()

# Bitwise AND (&) - 1 only if BOTH bits are 1
print("=== Bitwise AND (&) ===")
print(f"    {a:04b}  (a = {a})")
print(f"  & {b:04b}  (b = {b})")
print(f"  ------")
print(f"    {a & b:04b}  (result = {a & b})")
print()

# Bitwise OR (|) - 1 if AT LEAST ONE bit is 1
print("=== Bitwise OR (|) ===")
print(f"    {a:04b}  (a = {a})")
print(f"  | {b:04b}  (b = {b})")
print(f"  ------")
print(f"    {a | b:04b}  (result = {a | b})")
print()

# Bitwise XOR (^) - 1 if bits are DIFFERENT
print("=== Bitwise XOR (^) ===")
print(f"    {a:04b}  (a = {a})")
print(f"  ^ {b:04b}  (b = {b})")
print(f"  ------")
print(f"    {a ^ b:04b}  (result = {a ^ b})")
print()

# Bitwise NOT (~) - Inverts ALL bits
print("=== Bitwise NOT (~) ===")
print(f"~{a} = {~a}")
print("(Note: Python uses two's complement for negative numbers)")
