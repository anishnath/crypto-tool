# List Comprehensions
# A concise way to create lists based on existing lists.

numbers = [1, 2, 3, 4, 5]

# 1. Basic Syntax: [expression for item in iterable]
squares = [x**2 for x in numbers]
print(f"Original: {numbers}")
print(f"Squares: {squares}")

# 2. With Condition: [expression for item in iterable if condition]
evens = [x for x in numbers if x % 2 == 0]
print(f"Evens: {evens}")

# 3. Traditional way (for comparison)
doubles = []
for x in numbers:
    doubles.append(x * 2)
print(f"Doubles (loop): {doubles}")

# 4. String manipulation
fruits = ["apple", "banana", "cherry", "kiwi", "mango"]
newlist = [x.upper() for x in fruits if "a" in x]
print(f"\nFruits with 'a' (upper): {newlist}")

# 5. Nested List Comprehension (Flattening a matrix)
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flattened = [num for row in matrix for num in row]
print(f"\nMatrix: {matrix}")
print(f"Flattened: {flattened}")
