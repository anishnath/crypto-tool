# Nested Loops with 2D Data (Lists of Lists)

# 2D list (matrix)
matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]

# Iterate through rows and columns
print("=== Matrix Elements ===")
for row in matrix:
    for element in row:
        print(element, end=" ")
    print()  # New line after each row

print()

# Access with indices
print("=== With Row/Column Indices ===")
for i in range(len(matrix)):
    for j in range(len(matrix[i])):
        print(f"matrix[{i}][{j}] = {matrix[i][j]}")

print()

# Sum all elements
print("=== Sum of All Elements ===")
total = 0
for row in matrix:
    for element in row:
        total += element
print(f"Total: {total}")

print()

# Find specific value
print("=== Finding a Value ===")
target = 5
found = False
for i, row in enumerate(matrix):
    for j, value in enumerate(row):
        if value == target:
            print(f"Found {target} at position [{i}][{j}]")
            found = True
            break
    if found:
        break
