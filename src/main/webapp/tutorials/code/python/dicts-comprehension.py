# Dictionary Comprehensions
# Similar to list comprehensions, but for dictionaries.

# 1. Basic Syntax: {key: value for item in iterable}
squares = {x: x*x for x in range(6)}
print(f"Squares dict: {squares}")

# 2. From two lists (zipping)
keys = ['a', 'b', 'c']
values = [1, 2, 3]
my_dict = {k: v for k, v in zip(keys, values)}
print(f"Zipped dict: {my_dict}")

# 3. With Condition
# Create dict of even squares only
even_squares = {x: x*x for x in range(10) if x % 2 == 0}
print(f"Even squares: {even_squares}")

# 4. Transforming an existing dictionary
prices = {'apple': 0.40, 'orange': 0.35, 'banana': 0.25}
# Convert to price per dozen
dozen_prices = {k: v * 12 for k, v in prices.items()}
print(f"\nPrices: {prices}")
print(f"Dozen Prices: {dozen_prices}")
