# List Slicing - Extracting Sublists

numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
print(f"Original: {numbers}")
print(f"Indices:  0  1  2  3  4  5  6  7  8  9")
print()

# Basic slicing: list[start:end]
# Note: start is inclusive, end is exclusive
print("=== Basic Slicing [start:end] ===")
print(f"numbers[2:5] = {numbers[2:5]}")   # Elements 2, 3, 4
print(f"numbers[0:3] = {numbers[0:3]}")   # First 3 elements
print(f"numbers[7:10] = {numbers[7:10]}") # Last 3 elements

print()

# Omitting start or end
print("=== Omitting Start/End ===")
print(f"numbers[:4] = {numbers[:4]}")     # From beginning to 4
print(f"numbers[6:] = {numbers[6:]}")     # From 6 to end
print(f"numbers[:] = {numbers[:]}")       # Copy entire list

print()

# Negative indices in slicing
print("=== Negative Indices ===")
print(f"numbers[-4:] = {numbers[-4:]}")   # Last 4 elements
print(f"numbers[:-3] = {numbers[:-3]}")   # All except last 3
print(f"numbers[-5:-2] = {numbers[-5:-2]}") # From -5 to -2

print()

# Step parameter: list[start:end:step]
print("=== With Step [start:end:step] ===")
print(f"numbers[::2] = {numbers[::2]}")    # Every 2nd element
print(f"numbers[1::2] = {numbers[1::2]}")  # Odd indices
print(f"numbers[::3] = {numbers[::3]}")    # Every 3rd element

print()

# Reversing
print("=== Reversing ===")
print(f"numbers[::-1] = {numbers[::-1]}")  # Reverse entire list
print(f"numbers[5:2:-1] = {numbers[5:2:-1]}") # Reverse slice
