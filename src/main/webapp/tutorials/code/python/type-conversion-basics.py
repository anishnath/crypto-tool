# Type Conversion Basics in Python
# Converting values from one type to another

print("=" * 50)
print("1. Checking Types with type()")
print("=" * 50)

x = 42
y = 3.14
z = "hello"
b = True

print(f"type({x}) = {type(x)}")
print(f"type({y}) = {type(y)}")
print(f"type('{z}') = {type(z)}")
print(f"type({b}) = {type(b)}")

print("\n" + "=" * 50)
print("2. Converting to Integer: int()")
print("=" * 50)

# From float (truncates decimal)
print(f"int(3.7) = {int(3.7)}")      # 3 (not rounded!)
print(f"int(3.2) = {int(3.2)}")      # 3
print(f"int(-3.7) = {int(-3.7)}")    # -3 (towards zero)

# From string
print(f"int('42') = {int('42')}")
print(f"int('-100') = {int('-100')}")

# From boolean
print(f"int(True) = {int(True)}")    # 1
print(f"int(False) = {int(False)}")  # 0

# Different bases
print(f"int('1010', 2) = {int('1010', 2)}")  # 10 (binary)
print(f"int('FF', 16) = {int('FF', 16)}")    # 255 (hex)

print("\n" + "=" * 50)
print("3. Converting to Float: float()")
print("=" * 50)

# From integer
print(f"float(42) = {float(42)}")

# From string
print(f"float('3.14') = {float('3.14')}")
print(f"float('-2.5') = {float('-2.5')}")
print(f"float('1e-3') = {float('1e-3')}")  # Scientific notation

# Special values
print(f"float('inf') = {float('inf')}")
print(f"float('-inf') = {float('-inf')}")

print("\n" + "=" * 50)
print("4. Converting to String: str()")
print("=" * 50)

# From any type
print(f"str(42) = '{str(42)}'")
print(f"str(3.14) = '{str(3.14)}'")
print(f"str(True) = '{str(True)}'")
print(f"str(None) = '{str(None)}'")
print(f"str([1,2,3]) = '{str([1,2,3])}'")

print("\n" + "=" * 50)
print("5. Converting to Boolean: bool()")
print("=" * 50)

# From numbers (0 is False, others True)
print(f"bool(0) = {bool(0)}")
print(f"bool(1) = {bool(1)}")
print(f"bool(-5) = {bool(-5)}")
print(f"bool(0.0) = {bool(0.0)}")

# From strings (empty is False)
print(f"bool('') = {bool('')}")
print(f"bool('hello') = {bool('hello')}")
print(f"bool('False') = {bool('False')}")  # True! Non-empty string

# From collections (empty is False)
print(f"bool([]) = {bool([])}")
print(f"bool([1,2]) = {bool([1,2])}")
