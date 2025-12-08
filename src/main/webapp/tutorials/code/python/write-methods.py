# File Write Methods

# 1. write() - Write a string
print("=== write() Method ===")
with open("demo.txt", "w") as f:
    f.write("Hello, World!\n")
    f.write("Second line\n")
    chars_written = f.write("Third line")
    print(f"Last write: {chars_written} characters")

with open("demo.txt", "r") as f:
    print(f"Content:\n{f.read()}")
print()

# 2. writelines() - Write a list of strings
print("=== writelines() Method ===")
lines = ["Line 1\n", "Line 2\n", "Line 3\n"]
with open("lines.txt", "w") as f:
    f.writelines(lines)

with open("lines.txt", "r") as f:
    print(f"writelines result:\n{f.read()}")
print()

# 3. writelines() doesn't add newlines!
print("=== writelines() Without Newlines ===")
words = ["apple", "banana", "cherry"]
with open("words.txt", "w") as f:
    f.writelines(words)  # No newlines!

with open("words.txt", "r") as f:
    print(f"Result: {f.read()}")
print()

# 4. Adding newlines to writelines
print("=== writelines() With Newlines ===")
words = ["apple", "banana", "cherry"]
with open("words2.txt", "w") as f:
    # Add newlines using list comprehension
    f.writelines(line + "\n" for line in words)

with open("words2.txt", "r") as f:
    print(f"Result:\n{f.read()}")
print()

# 5. write() returns character count
print("=== Write Return Value ===")
with open("count.txt", "w") as f:
    count1 = f.write("Short")
    count2 = f.write("A longer string here")
    print(f"First write: {count1} chars")
    print(f"Second write: {count2} chars")

# Cleanup
import os
for fname in ["demo.txt", "lines.txt", "words.txt", "words2.txt", "count.txt"]:
    os.remove(fname)
print("\n(Cleaned up files)")
