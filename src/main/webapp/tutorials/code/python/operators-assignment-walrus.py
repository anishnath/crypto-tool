# The Walrus Operator := (Python 3.8+)
# Assigns AND returns a value in one expression

# Without walrus operator
numbers = [1, 2, 3, 4, 5]
n = len(numbers)
if n > 3:
    print(f"List has {n} elements (using traditional approach)")

# With walrus operator - assign and use in same expression
if (count := len(numbers)) > 3:
    print(f"List has {count} elements (using walrus operator)")

print()

# Useful in while loops
print("=== Walrus in While Loop ===")
data = ["line 1", "line 2", "line 3", ""]

# Simulate reading lines until empty
index = 0
while (line := data[index] if index < len(data) else "") != "":
    print(f"Processing: {line}")
    index += 1

print()

# Useful in list comprehensions
print("=== Walrus in List Comprehension ===")
values = [1, 2, 3, 4, 5]

# Only include squares greater than 10
# Calculate square once with walrus, use twice
large_squares = [square for x in values if (square := x**2) > 10]
print(f"Squares > 10: {large_squares}")

print()

# Filtering with computation
words = ["hello", "hi", "world", "python"]
# Keep words with length > 3, showing the length
long_words = [(w, length) for w in words if (length := len(w)) > 3]
print(f"Long words with lengths: {long_words}")
