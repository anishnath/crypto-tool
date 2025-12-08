# File Write Modes

# 1. Write mode ('w') - creates new or OVERWRITES existing!
print("=== Write Mode ('w') ===")
with open("output.txt", "w") as f:
    f.write("First write.\n")
    f.write("This is new content.")

# Read it back
with open("output.txt", "r") as f:
    print(f.read())
print()

# Write again - previous content is GONE!
with open("output.txt", "w") as f:
    f.write("Completely new content!")

with open("output.txt", "r") as f:
    print(f"After second write: {f.read()}")
print()

# 2. Append mode ('a') - adds to end of file
print("=== Append Mode ('a') ===")
with open("log.txt", "w") as f:
    f.write("Log started\n")

# Append multiple times
for i in range(1, 4):
    with open("log.txt", "a") as f:
        f.write(f"Entry {i}: Something happened\n")

with open("log.txt", "r") as f:
    print(f.read())
print()

# 3. Exclusive create ('x') - fails if file exists
print("=== Exclusive Create ('x') ===")
import os
if os.path.exists("unique.txt"):
    os.remove("unique.txt")

with open("unique.txt", "x") as f:
    f.write("This file is brand new!")
print("Created unique.txt successfully")

try:
    with open("unique.txt", "x") as f:
        f.write("Try again")
except FileExistsError:
    print("Error: File already exists! Cannot use 'x' mode.")
print()

# 4. Read/Write mode ('r+', 'w+')
print("=== Read/Write Modes ===")
with open("readwrite.txt", "w+") as f:
    f.write("Original content")
    f.seek(0)  # Go back to start to read
    print(f"r+ mode: {f.read()}")

# Cleanup
for fname in ["output.txt", "log.txt", "unique.txt", "readwrite.txt"]:
    os.remove(fname)
print("\n(Cleaned up files)")
