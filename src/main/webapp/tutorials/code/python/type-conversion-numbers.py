# Numeric Type Conversions in Python
# Converting between int, float, and complex

print("=" * 50)
print("1. Integer to Float")
print("=" * 50)

x = 42
print(f"x = {x} (type: {type(x).__name__})")
x_float = float(x)
print(f"float(x) = {x_float} (type: {type(x_float).__name__})")

# Automatic conversion in division
result = 10 / 4
print(f"\n10 / 4 = {result} (type: {type(result).__name__})")

# Integer division stays integer
result = 10 // 4
print(f"10 // 4 = {result} (type: {type(result).__name__})")

print("\n" + "=" * 50)
print("2. Float to Integer (Truncation)")
print("=" * 50)

y = 3.7
print(f"y = {y}")
print(f"int(y) = {int(y)}")  # 3, NOT 4!

# Different rounding methods
import math
print(f"\nDifferent ways to round {y}:")
print(f"  int():       {int(y)}")           # 3 (truncate)
print(f"  round():     {round(y)}")         # 4 (round to nearest)
print(f"  math.floor(): {math.floor(y)}")   # 3 (round down)
print(f"  math.ceil():  {math.ceil(y)}")    # 4 (round up)
print(f"  math.trunc(): {math.trunc(y)}")   # 3 (truncate)

# Negative numbers
neg = -3.7
print(f"\nFor negative {neg}:")
print(f"  int():       {int(neg)}")          # -3 (towards zero)
print(f"  math.floor(): {math.floor(neg)}")  # -4 (towards -inf)
print(f"  math.ceil():  {math.ceil(neg)}")   # -3 (towards +inf)

print("\n" + "=" * 50)
print("3. Complex Numbers")
print("=" * 50)

# Creating complex numbers
c1 = complex(3, 4)   # 3 + 4j
c2 = 3 + 4j          # Same thing

print(f"complex(3, 4) = {c1}")
print(f"Real part: {c1.real}")
print(f"Imaginary part: {c1.imag}")

# From other types
print(f"\ncomplex(5) = {complex(5)}")
print(f"complex(2.5) = {complex(2.5)}")

# Cannot convert complex to int/float directly!
# int(c1) would raise TypeError

print("\n" + "=" * 50)
print("4. Automatic Type Coercion")
print("=" * 50)

# Python automatically converts to more general type
print("int + float = float:")
result = 5 + 2.5
print(f"  5 + 2.5 = {result} ({type(result).__name__})")

print("\nint + complex = complex:")
result = 5 + 3j
print(f"  5 + 3j = {result} ({type(result).__name__})")

print("\nfloat + complex = complex:")
result = 2.5 + 3j
print(f"  2.5 + 3j = {result} ({type(result).__name__})")

# Hierarchy: int < float < complex
print("\nType hierarchy: int → float → complex")
