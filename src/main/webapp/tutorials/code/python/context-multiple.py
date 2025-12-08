# Multiple Context Managers

import os

# Create test files
for name in ["input.txt", "config.txt"]:
    with open(name, "w") as f:
        f.write(f"Contents of {name}\n")

# 1. Multiple files in one 'with' statement
print("=== Multiple Files (Single Line) ===")
with open("input.txt", "r") as infile, open("output.txt", "w") as outfile:
    content = infile.read()
    outfile.write(f"Copied: {content}")
    print(f"infile.closed: {infile.closed}")
    print(f"outfile.closed: {outfile.closed}")

print(f"After 'with' - both closed: {infile.closed and outfile.closed}")
print()

# 2. Multiple files (multi-line for readability)
print("=== Multiple Files (Multi-line) ===")
with (
    open("input.txt", "r") as source,
    open("backup.txt", "w") as backup,
    open("log.txt", "w") as log
):
    data = source.read()
    backup.write(data)
    log.write("Backup created successfully\n")
    print("Wrote to 3 files simultaneously")
print()

# 3. Nested context managers
print("=== Nested Context Managers ===")
with open("input.txt", "r") as outer:
    print(f"Outer file opened: {outer.name}")
    with open("config.txt", "r") as inner:
        print(f"Inner file opened: {inner.name}")
        # Both files accessible here
        print(f"Outer content: {outer.read().strip()}")
        print(f"Inner content: {inner.read().strip()}")
    print(f"Inner closed: {inner.closed}")
print(f"Outer closed: {outer.closed}")
print()

# 4. Reading and writing - file copy
print("=== Practical Example: File Copy ===")
with open("input.txt", "r") as src, open("copy.txt", "w") as dst:
    for line in src:
        dst.write(line.upper())

with open("copy.txt", "r") as f:
    print(f"Copied content (uppercase): {f.read().strip()}")

# Cleanup
for name in ["input.txt", "output.txt", "backup.txt", "log.txt", "config.txt", "copy.txt"]:
    if os.path.exists(name):
        os.remove(name)
print("\n(Cleaned up all test files)")
