
thistuple = (1, 3, 7, 8, 7, 5, 4, 6, 8, 5)

# Find index of 8
x = thistuple.index(8)
print(f"Index of 8: {x}")

# Find index of 8, starting search from index 4
y = thistuple.index(8, 4)
print(f"Index of 8 (after index 4): {y}")

# Note: index() raises ValueError if item is not found
# z = thistuple.index(9) # Raises Error
