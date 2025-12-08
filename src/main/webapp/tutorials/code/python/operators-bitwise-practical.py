# Practical Bitwise Applications

# 1. Permission Flags (like Unix file permissions)
print("=== Permission Flags ===")
READ = 0b100     # 4
WRITE = 0b010    # 2
EXECUTE = 0b001  # 1

# Grant permissions with OR
permissions = READ | WRITE  # rwx = 110 = 6
print(f"READ | WRITE = {permissions} ({permissions:03b})")

# Check permission with AND
has_read = permissions & READ
has_execute = permissions & EXECUTE
print(f"Has READ? {bool(has_read)}")
print(f"Has EXECUTE? {bool(has_execute)}")

# Revoke permission with AND + NOT
permissions = permissions & ~WRITE  # Remove WRITE
print(f"After revoking WRITE: {permissions} ({permissions:03b})")

# Toggle permission with XOR
permissions = permissions ^ EXECUTE  # Toggle EXECUTE
print(f"After toggling EXECUTE: {permissions} ({permissions:03b})")

print()

# 2. Checking if a number is even or odd
print("=== Even/Odd Check ===")
for n in [4, 7, 12, 15]:
    is_odd = n & 1  # Last bit is 1 for odd numbers
    print(f"{n} is {'odd' if is_odd else 'even'} (binary: {n:04b})")

print()

# 3. Swapping values without temp variable
print("=== XOR Swap ===")
a, b = 10, 25
print(f"Before: a = {a}, b = {b}")
a = a ^ b
b = a ^ b
a = a ^ b
print(f"After:  a = {a}, b = {b}")

print()

# 4. Finding unique element (XOR trick)
print("=== Find Unique Element ===")
numbers = [2, 3, 5, 3, 2]  # 5 appears once
result = 0
for num in numbers:
    result ^= num
print(f"List: {numbers}")
print(f"Unique element: {result}")
