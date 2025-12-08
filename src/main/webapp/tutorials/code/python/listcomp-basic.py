# Basic List Comprehensions

# The syntax: [expression for item in iterable]

# Traditional for loop approach
numbers = [1, 2, 3, 4, 5]
squares_loop = []
for n in numbers:
    squares_loop.append(n ** 2)
print(f"Using loop: {squares_loop}")

# List comprehension approach - same result, one line!
squares_comp = [n ** 2 for n in numbers]
print(f"Using comprehension: {squares_comp}")
print()

# More examples
print("=== More Examples ===")

# Double each number
doubles = [x * 2 for x in range(5)]
print(f"Doubles of 0-4: {doubles}")

# Convert to strings
str_nums = [str(x) for x in range(1, 6)]
print(f"Numbers as strings: {str_nums}")

# Uppercase words
words = ["hello", "world", "python"]
upper_words = [word.upper() for word in words]
print(f"Uppercase: {upper_words}")

# Get lengths
lengths = [len(word) for word in words]
print(f"Lengths: {lengths}")
print()

# Using different expressions
print("=== Various Expressions ===")
nums = [1, 2, 3, 4, 5]

# Expression can be any valid Python expression
results = [
    [x for x in nums],           # Identity
    [x + 10 for x in nums],      # Add 10
    [x ** 2 for x in nums],      # Square
    [x * x * x for x in nums],   # Cube
    [-x for x in nums],          # Negate
]

labels = ["Identity", "Add 10", "Square", "Cube", "Negate"]
for label, result in zip(labels, results):
    print(f"  {label}: {result}")
