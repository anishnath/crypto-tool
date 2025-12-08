# Iterating Through Files

# Create sample file
with open("data.txt", "w") as f:
    for i in range(1, 6):
        f.write(f"Line {i}: Data entry number {i}\n")

# 1. Iterate line by line (most memory efficient)
print("=== Iterate Line by Line ===")
f = open("data.txt", "r")
for line in f:
    print(line.strip())
f.close()
print()

# 2. Using enumerate for line numbers
print("=== With Line Numbers (enumerate) ===")
f = open("data.txt", "r")
for line_num, line in enumerate(f, 1):
    print(f"{line_num}: {line.strip()}")
f.close()
print()

# 3. Read into list, then iterate
print("=== Process as List ===")
f = open("data.txt", "r")
lines = f.readlines()
f.close()

# Now work with the list
print(f"Total lines: {len(lines)}")
print(f"First line: {lines[0].strip()}")
print(f"Last line: {lines[-1].strip()}")
print()

# 4. Using with statement (recommended!)
print("=== Using 'with' Statement ===")
with open("data.txt", "r") as f:
    for line in f:
        if "3" in line:
            print(f"Found: {line.strip()}")
# File automatically closed after 'with' block
print()

# 5. Read specific lines
print("=== Read Lines 2-4 ===")
with open("data.txt", "r") as f:
    for i, line in enumerate(f, 1):
        if 2 <= i <= 4:
            print(line.strip())

# Cleanup
import os
os.remove("data.txt")
