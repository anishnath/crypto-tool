# Basic Dictionary Comprehensions

# Syntax: {key_expr: value_expr for item in iterable}

# 1. Traditional way (for comparison)
print("=== Traditional Loop ===")
squares_loop = {}
for x in range(6):
    squares_loop[x] = x ** 2
print(f"Using loop: {squares_loop}")

# 2. Dict comprehension - same result, one line!
print("\n=== Dict Comprehension ===")
squares_comp = {x: x ** 2 for x in range(6)}
print(f"Using comprehension: {squares_comp}")

print()

# 3. More examples
print("=== More Examples ===")

# String lengths
words = ["apple", "banana", "cherry"]
lengths = {word: len(word) for word in words}
print(f"Word lengths: {lengths}")

# Index mapping
chars = "hello"
char_index = {char: i for i, char in enumerate(chars)}
print(f"Char indices: {char_index}")

# ASCII values
ascii_map = {char: ord(char) for char in "ABC"}
print(f"ASCII values: {ascii_map}")

print()

# 4. From two lists using zip
print("=== From Two Lists (zip) ===")
names = ["Alice", "Bob", "Charlie"]
ages = [25, 30, 35]

name_age = {name: age for name, age in zip(names, ages)}
print(f"Names: {names}")
print(f"Ages: {ages}")
print(f"Zipped: {name_age}")

print()

# 5. From list of tuples
print("=== From List of Tuples ===")
pairs = [("a", 1), ("b", 2), ("c", 3)]
from_pairs = {k: v for k, v in pairs}
print(f"From pairs: {from_pairs}")
