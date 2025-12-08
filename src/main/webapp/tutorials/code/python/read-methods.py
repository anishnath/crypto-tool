# File Reading Methods

# Create a sample file
with open("demo.txt", "w") as f:
    f.write("Line 1: Hello World!\n")
    f.write("Line 2: Python is awesome!\n")
    f.write("Line 3: File handling made easy.\n")
    f.write("Line 4: The end.")

# 1. read() - Read entire file
print("=== read() - Entire File ===")
f = open("demo.txt", "r")
content = f.read()
print(content)
f.close()
print()

# 2. read(n) - Read n characters
print("=== read(n) - First 20 Characters ===")
f = open("demo.txt", "r")
partial = f.read(20)
print(f"'{partial}'")
# Continue reading from current position
more = f.read(10)
print(f"Next 10: '{more}'")
f.close()
print()

# 3. readline() - Read one line
print("=== readline() - One Line at a Time ===")
f = open("demo.txt", "r")
line1 = f.readline()
line2 = f.readline()
print(f"Line 1: {line1.strip()}")
print(f"Line 2: {line2.strip()}")
f.close()
print()

# 4. readlines() - All lines as list
print("=== readlines() - List of Lines ===")
f = open("demo.txt", "r")
lines = f.readlines()
print(f"Number of lines: {len(lines)}")
print(f"Lines: {lines}")
f.close()
print()

# 5. Combining with strip() to remove newlines
print("=== Clean Lines (strip newlines) ===")
f = open("demo.txt", "r")
clean_lines = [line.strip() for line in f.readlines()]
print(clean_lines)
f.close()

# Cleanup
import os
os.remove("demo.txt")
