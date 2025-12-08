# Basic Nested Loops

# The inner loop runs completely for each outer loop iteration
print("=== Basic Nested Loop ===")
for i in range(3):  # Outer loop: runs 3 times
    print(f"Outer loop i = {i}")
    for j in range(2):  # Inner loop: runs 2 times PER outer iteration
        print(f"  Inner loop j = {j}")

print()

# Counting total iterations
print("=== Counting Iterations ===")
outer_count = 0
inner_count = 0

for i in range(4):
    outer_count += 1
    for j in range(3):
        inner_count += 1

print(f"Outer loop ran: {outer_count} times")
print(f"Inner loop ran: {inner_count} times")  # 4 * 3 = 12

print()

# Multiplication table
print("=== Multiplication Table (1-5) ===")
for i in range(1, 6):
    row = ""
    for j in range(1, 6):
        row += f"{i*j:4}"  # 4-character width
    print(row)
