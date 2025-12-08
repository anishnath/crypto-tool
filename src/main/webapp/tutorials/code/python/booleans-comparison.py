# Comparison Operators in Python
# All comparison operators return boolean values

print("=" * 50)
print("1. Basic Comparison Operators")
print("=" * 50)

a, b = 10, 20
print(f"a = {a}, b = {b}")
print()
print(f"a == b (equal):              {a == b}")   # False
print(f"a != b (not equal):          {a != b}")   # True
print(f"a < b  (less than):          {a < b}")    # True
print(f"a > b  (greater than):       {a > b}")    # False
print(f"a <= b (less or equal):      {a <= b}")   # True
print(f"a >= b (greater or equal):   {a >= b}")   # False

print("\n" + "=" * 50)
print("2. Comparing Different Types")
print("=" * 50)

# Numbers can be compared across types
print(f"10 == 10.0: {10 == 10.0}")     # True
print(f"10 == '10': {10 == '10'}")     # False (int vs string)

# Strings compare lexicographically (dictionary order)
print(f"'apple' < 'banana': {'apple' < 'banana'}")   # True
print(f"'Apple' < 'apple': {'Apple' < 'apple'}")     # True (uppercase < lowercase)

print("\n" + "=" * 50)
print("3. Chained Comparisons")
print("=" * 50)

# Python allows chained comparisons!
x = 15
print(f"x = {x}")
print(f"10 < x < 20: {10 < x < 20}")       # True
print(f"0 < x < 10:  {0 < x < 10}")        # False
print(f"10 <= x <= 20: {10 <= x <= 20}")   # True

# Equivalent to:
print(f"(10 < x) and (x < 20): {(10 < x) and (x < 20)}")

print("\n" + "=" * 50)
print("4. Identity Operators (is, is not)")
print("=" * 50)

# 'is' checks if same object in memory, not just equal value
a = [1, 2, 3]
b = [1, 2, 3]
c = a

print(f"a = {a}")
print(f"b = {b}")
print(f"c = a")
print()
print(f"a == b: {a == b}")     # True (same values)
print(f"a is b: {a is b}")     # False (different objects)
print(f"a is c: {a is c}")     # True (same object)

# Common use: checking for None
value = None
print(f"\nvalue is None: {value is None}")    # True

print("\n" + "=" * 50)
print("5. Membership Operators (in, not in)")
print("=" * 50)

fruits = ["apple", "banana", "cherry"]
print(f"fruits = {fruits}")
print(f"'apple' in fruits: {'apple' in fruits}")       # True
print(f"'mango' in fruits: {'mango' in fruits}")       # False
print(f"'mango' not in fruits: {'mango' not in fruits}")  # True

# Works with strings too
text = "Hello World"
print(f"\n'World' in '{text}': {'World' in text}")   # True
