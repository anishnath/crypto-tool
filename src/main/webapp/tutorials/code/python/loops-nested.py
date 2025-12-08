# Nested Loops
# A loop inside another loop.

# 1. Multiplication Table
print("Multiplication Table (1-3):")
for i in range(1, 4):      # Outer loop
    for j in range(1, 4):  # Inner loop
        print(f"{i} * {j} = {i*j}")
    print("---") # Separator between outer loop iterations

# 2. Coordinates
print("\nCoordinates:")
x_coords = [1, 2]
y_coords = [1, 2]

for x in x_coords:
    for y in y_coords:
        print(f"({x}, {y})")

# 3. Breaking out of nested loops
# 'break' only breaks the innermost loop
print("\nBreaking Inner Loop:")
for i in range(3):
    print(f"Outer {i}")
    for j in range(3):
        if j == 1:
            print("  Breaking inner")
            break
        print(f"  Inner {j}")
