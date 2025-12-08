# Python Context Managers (with statement)
# It is good practice to use the 'with' statement when dealing with file objects.
# The advantage is that the file is properly closed after its suite finishes, even if an exception is raised at some point.

# 1. Reading with 'with'
print("--- Reading with 'with' ---")
with open("demofile.txt", "r") as f:
    content = f.read()
    print(content)

# Check if file is closed
print(f"\nIs file closed? {f.closed}")

# 2. Writing with 'with'
print("\n--- Writing with 'with' ---")
with open("demofile_context.txt", "w") as f:
    f.write("This file was created using a context manager.")

with open("demofile_context.txt", "r") as f:
    print(f.read())
