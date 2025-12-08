# Nested List Comprehensions

# 1. Flattening a 2D list
print("=== Flattening a Matrix ===")
matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]
print(f"Matrix: {matrix}")

# Traditional nested loop
flat_loop = []
for row in matrix:
    for num in row:
        flat_loop.append(num)
print(f"Flattened (loop): {flat_loop}")

# List comprehension - read left to right
flat_comp = [num for row in matrix for num in row]
print(f"Flattened (comp): {flat_comp}")
print()

# 2. Creating a 2D list
print("=== Creating a Matrix ===")
# 3x3 matrix of zeros
zeros = [[0 for col in range(3)] for row in range(3)]
print(f"3x3 zeros: {zeros}")

# Multiplication table
mult_table = [[i * j for j in range(1, 4)] for i in range(1, 4)]
print(f"Mult table:")
for row in mult_table:
    print(f"  {row}")
print()

# 3. Nested with conditions
print("=== Nested with Filter ===")
# Get all even numbers from matrix
even_nums = [num for row in matrix for num in row if num % 2 == 0]
print(f"Even from matrix: {even_nums}")

# Get diagonal elements (where row index == col index)
diagonal = [matrix[i][i] for i in range(len(matrix))]
print(f"Diagonal: {diagonal}")
print()

# 4. All combinations
print("=== All Combinations ===")
colors = ["red", "green"]
sizes = ["S", "M", "L"]

# Cartesian product
combinations = [(c, s) for c in colors for s in sizes]
print(f"Color-Size combos: {combinations}")

# As formatted strings
combo_strings = [f"{c}-{s}" for c in colors for s in sizes]
print(f"As strings: {combo_strings}")
