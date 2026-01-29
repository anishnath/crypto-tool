# Memory Efficiency: Iterators vs Lists

import sys

# List stores ALL values in memory at once
def create_large_list(n):
    """Creates a list with n elements - all in memory."""
    return list(range(n))

# Iterator generates values on-demand
def create_large_iterator(n):
    """Creates an iterator that generates values on-demand."""
    for i in range(n):
        yield i

# Compare memory usage
n = 1000000

print(f"Memory comparison for {n} elements:")
print("-" * 50)

# List: all values stored in memory
large_list = create_large_list(n)
list_size = sys.getsizeof(large_list)
print(f"List size: {list_size:,} bytes")

# Iterator: minimal memory (just the iterator object)
large_iter = create_large_iterator(n)
iter_size = sys.getsizeof(large_iter)
print(f"Iterator size: {iter_size:,} bytes")

print(f"\nIterator uses {list_size // iter_size}x less memory!")
print(f"List: {list_size:,} bytes")
print(f"Iterator: {iter_size:,} bytes")

# Practical example: processing large files
print("\n" + "-" * 50)
print("Practical example: Processing large data")

# This would use huge memory with a list
def process_with_list(data):
    """Processes all data at once - memory intensive."""
    results = []
    for item in data:
        results.append(item * 2)
    return results

# This processes one item at a time - memory efficient
def process_with_iterator(data):
    """Processes data one item at a time - memory efficient."""
    for item in data:
        yield item * 2

# With list: all results stored
# With iterator: results generated on-demand
numbers = range(100)
print("Using iterator (generates on-demand):")
for result in process_with_iterator(numbers):
    if result > 10:  # Can stop early!
        break
    print(result, end=" ")
print("\n(Stopped early - didn't process all items)")





