# Memory Efficiency: Generators vs Lists

import sys

def squares_list(n):
    """Creates a list of squares - all in memory."""
    result = []
    for i in range(n):
        result.append(i ** 2)
    return result

def squares_generator(n):
    """Generator that yields squares on-demand."""
    for i in range(n):
        yield i ** 2


# Memory comparison
n = 10000

print("Memory comparison for squares of numbers 0 to", n-1)
print("-" * 60)

# List approach
squares_as_list = squares_list(n)
list_size = sys.getsizeof(squares_as_list)
print(f"List size: {list_size:,} bytes")

# Generator approach
squares_as_gen = squares_generator(n)
gen_size = sys.getsizeof(squares_as_gen)
print(f"Generator size: {gen_size:,} bytes")

print(f"\nGenerator uses {list_size // gen_size}x less memory!")

# Practical example: Reading large file
print("\n" + "-" * 60)
print("Practical example: Processing large dataset")

def read_lines_list(filename):
    """Reads all lines into memory (memory intensive)."""
    with open(filename, 'r') as f:
        return f.readlines()  # All lines in memory at once

def read_lines_generator(filename):
    """Yields lines one at a time (memory efficient)."""
    with open(filename, 'r') as f:
        for line in f:
            yield line.strip()  # One line at a time

# For demonstration with a simple range
def process_numbers_list(n):
    """Processes all numbers at once."""
    return [x * 2 for x in range(n)]

def process_numbers_generator(n):
    """Processes numbers one at a time."""
    for x in range(n):
        yield x * 2

print("\nWith generator, you can stop early:")
gen = process_numbers_generator(1000)
count = 0
for value in gen:
    if count >= 5:  # Stop after 5 values
        break
    print(value, end=" ")
    count += 1
print("\n(Processed only what we needed, not all 1000 items)")

