# Formatted File Output

import os

# 1. print() to file
print("=== print() to File ===")
with open("output.txt", "w") as f:
    print("Hello, File!", file=f)
    print("Line 2", file=f)
    print(1, 2, 3, sep="-", file=f)

with open("output.txt", "r") as f:
    print(f.read())
print()

# 2. f-strings for formatting
print("=== f-string Formatting ===")
name = "Alice"
score = 95.5
level = 3

with open("formatted.txt", "w") as f:
    f.write(f"Player: {name}\n")
    f.write(f"Score: {score:.1f}\n")
    f.write(f"Level: {level:03d}\n")

with open("formatted.txt", "r") as f:
    print(f.read())
print()

# 3. format() method
print("=== format() Method ===")
template = "Name: {}, Age: {}, City: {}\n"
people = [
    ("Alice", 30, "New York"),
    ("Bob", 25, "London"),
    ("Charlie", 35, "Paris")
]

with open("people.txt", "w") as f:
    for person in people:
        f.write(template.format(*person))

with open("people.txt", "r") as f:
    print(f.read())
print()

# 4. Tabular data with formatting
print("=== Formatted Table ===")
data = [
    ("Product", "Price", "Qty"),
    ("Apple", 1.50, 10),
    ("Banana", 0.75, 25),
    ("Orange", 2.00, 15)
]

with open("table.txt", "w") as f:
    for row in data:
        if isinstance(row[1], str):  # Header row
            f.write(f"{row[0]:<12}{row[1]:<10}{row[2]:<8}\n")
            f.write("-" * 30 + "\n")
        else:
            f.write(f"{row[0]:<12}${row[1]:<9.2f}{row[2]:<8}\n")

with open("table.txt", "r") as f:
    print(f.read())
print()

# 5. Multiple writes with join
print("=== join() for Efficiency ===")
lines = ["Line 1", "Line 2", "Line 3", "Line 4"]

# Efficient: join then single write
with open("joined.txt", "w") as f:
    f.write("\n".join(lines))

with open("joined.txt", "r") as f:
    print(f.read())

# Cleanup
for fname in ["output.txt", "formatted.txt", "people.txt", "table.txt", "joined.txt"]:
    os.remove(fname)
print("\n(Cleaned up files)")
