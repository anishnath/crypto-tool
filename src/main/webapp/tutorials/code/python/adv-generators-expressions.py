# Generator Expressions

# List comprehension: creates a list (all values in memory)
squares_list = [x**2 for x in range(5)]
print("List comprehension:", squares_list)
print("Type:", type(squares_list))

# Generator expression: creates a generator (values generated on-demand)
squares_gen = (x**2 for x in range(5))
print("\nGenerator expression:", squares_gen)
print("Type:", type(squares_gen))

# Convert generator to list if needed
print("Values from generator:", list(squares_gen))

# Generator expressions are memory efficient
print("\nMemory efficiency:")
import sys

# List: all values stored
list_size = sys.getsizeof([x**2 for x in range(1000)])
print(f"List size (1000 items): {list_size:,} bytes")

# Generator: minimal memory
gen_size = sys.getsizeof((x**2 for x in range(1000)))
print(f"Generator size (1000 items): {gen_size:,} bytes")

# Using generator expressions with built-in functions
print("\nUsing with sum() (memory efficient):")
total = sum(x**2 for x in range(10))
print(f"Sum of squares 0-9: {total}")

# Using with max()
print("\nUsing with max():")
max_val = max(x**2 for x in range(10))
print(f"Max square 0-9: {max_val}")

# Filtering with generator expressions
print("\nFiltering with generator expression:")
evens = (x for x in range(20) if x % 2 == 0)
print("Even numbers:", list(evens))

# Chaining generator expressions
print("\nChaining generators:")
numbers = range(10)
squared = (x**2 for x in numbers)
filtered = (x for x in squared if x > 10)
print("Squares > 10:", list(filtered))





