# Python Reading Files
# The open() function returns a file object, which has a read() method for reading the content of the file.

# Note: For this example to work, we assume a file named 'demofile.txt' exists.
# We will create it first for demonstration purposes.
with open("demofile.txt", "w") as f:
    f.write("Line 1: Hello World!\nLine 2: Python File Handling\nLine 3: End of file.")

# 1. Open and Read the whole file
f = open("demofile.txt", "r")
print("--- Read All ---")
print(f.read())
f.close()

# 2. Read Only Parts of the File
f = open("demofile.txt", "r")
print("\n--- Read First 5 Characters ---")
print(f.read(5))
f.close()

# 3. Read Lines
f = open("demofile.txt", "r")
print("\n--- Read Line ---")
print(f.readline()) # Reads first line
f.close()

# 4. Read All Lines into a List
f = open("demofile.txt", "r")
print("\n--- Read Lines (List) ---")
lines = f.readlines()
print(lines)
f.close()
