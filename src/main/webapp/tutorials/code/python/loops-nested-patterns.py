# Pattern Printing with Nested Loops

# Right triangle
print("=== Right Triangle ===")
rows = 5
for i in range(1, rows + 1):
    for j in range(i):
        print("*", end="")
    print()

print()

# Inverted right triangle
print("=== Inverted Right Triangle ===")
for i in range(rows, 0, -1):
    for j in range(i):
        print("*", end="")
    print()

print()

# Square
print("=== Square ===")
size = 4
for i in range(size):
    for j in range(size):
        print("*", end=" ")
    print()

print()

# Number pyramid
print("=== Number Pyramid ===")
for i in range(1, 6):
    # Print leading spaces
    for space in range(5 - i):
        print(" ", end="")
    # Print numbers
    for num in range(1, i + 1):
        print(num, end="")
    print()

print()

# Rectangle with border
print("=== Rectangle with Border ===")
width, height = 6, 4
for i in range(height):
    for j in range(width):
        if i == 0 or i == height-1 or j == 0 or j == width-1:
            print("*", end="")
        else:
            print(" ", end="")
    print()
