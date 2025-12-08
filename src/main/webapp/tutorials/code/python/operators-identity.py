# Identity Operators: 'is' and 'is not'
# Check if two variables point to the SAME object in memory

print("=== Understanding 'is' ===")

# Two variables pointing to same object
a = [1, 2, 3]
b = a  # b points to the same list as a
print(f"a = {a}")
print(f"b = a")
print(f"a is b: {a is b}")  # True - same object
print(f"id(a): {id(a)}")
print(f"id(b): {id(b)}")  # Same ID!

print()

# Two variables with equal values, different objects
x = [1, 2, 3]
y = [1, 2, 3]  # New list with same values
print(f"x = {x}")
print(f"y = {y}")
print(f"x is y: {x is y}")  # False - different objects
print(f"x == y: {x == y}")  # True - same values
print(f"id(x): {id(x)}")
print(f"id(y): {id(y)}")  # Different IDs!

print()

# 'is not' operator
print("=== Understanding 'is not' ===")
print(f"x is not y: {x is not y}")  # True - different objects
print(f"a is not b: {a is not b}")  # False - same object

print()

# Small integer caching (Python optimization)
print("=== Python Caching (Small Integers) ===")
small1 = 5
small2 = 5
print(f"small1 = 5, small2 = 5")
print(f"small1 is small2: {small1 is small2}")  # True (Python caches -5 to 256)

large1 = 1000
large2 = 1000
print(f"large1 = 1000, large2 = 1000")
print(f"large1 is large2: {large1 is large2}")  # May be True or False!
print("(Result depends on Python implementation)")
