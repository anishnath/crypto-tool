# Dictionary Comprehensions: Transformations

# Transform existing dictionaries

# 1. Transform values
print("=== Transform Values ===")
prices = {"apple": 1.20, "banana": 0.50, "cherry": 2.00}
print(f"Original prices: {prices}")

# Apply discount (20% off)
discounted = {item: round(price * 0.8, 2) for item, price in prices.items()}
print(f"20% discount: {discounted}")

# Convert to cents
in_cents = {item: int(price * 100) for item, price in prices.items()}
print(f"In cents: {in_cents}")
print()

# 2. Transform keys
print("=== Transform Keys ===")
data = {"name": "Alice", "age": 30, "city": "NYC"}
print(f"Original: {data}")

# Uppercase keys
upper_keys = {k.upper(): v for k, v in data.items()}
print(f"Uppercase keys: {upper_keys}")

# Prefix keys
prefixed = {f"user_{k}": v for k, v in data.items()}
print(f"Prefixed keys: {prefixed}")
print()

# 3. Transform both keys and values
print("=== Transform Both ===")
scores = {"alice": 85, "bob": 90, "charlie": 78}
print(f"Original: {scores}")

# Capitalize names, add grade labels
graded = {name.capitalize(): f"Grade: {score}" for name, score in scores.items()}
print(f"Transformed: {graded}")
print()

# 4. Swap keys and values
print("=== Swap Keys and Values ===")
original = {"a": 1, "b": 2, "c": 3}
swapped = {v: k for k, v in original.items()}
print(f"Original: {original}")
print(f"Swapped: {swapped}")
print()

# 5. Conditional transformation (if-else in expression)
print("=== Conditional Transform ===")
numbers = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5}
# Double evens, triple odds
transformed = {k: v*2 if v % 2 == 0 else v*3 for k, v in numbers.items()}
print(f"Original: {numbers}")
print(f"Double evens, triple odds: {transformed}")
