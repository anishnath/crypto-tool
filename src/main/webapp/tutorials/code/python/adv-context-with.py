# The with Statement

# Most common use: file handling
# File is automatically closed even if exception occurs

# Without with (manual management - error-prone)
print("Without with statement:")
file = open('example.txt', 'w')
try:
    file.write("Hello, World!")
finally:
    file.close()  # Must remember to close!

# With with statement (automatic cleanup)
print("\nWith statement:")
with open('example.txt', 'w') as f:
    f.write("Hello, World!")
# File automatically closed here, even if exception occurs

# Reading files with with
with open('example.txt', 'r') as f:
    content = f.read()
    print("File content:", content)

# Multiple operations with same file
with open('example.txt', 'r') as f:
    lines = f.readlines()
    print(f"Number of lines: {len(lines)}")


# Exception handling with with
print("\nException handling:")
try:
    with open('example.txt', 'r') as f:
        # File will be closed even if exception occurs
        content = f.read()
        # Simulate an error
        # result = 1 / 0  # Would raise ZeroDivisionError
        print("File read successfully")
except Exception as e:
    print(f"Error: {e}")
# File is still closed here automatically

