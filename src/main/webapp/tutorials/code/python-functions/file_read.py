
# Setup: Create a file to read
with open("demofile.txt", "w") as f:
    f.write("Hello! Welcome to demofile.txt\nThis is the second line.\nThis is the third line.")

# Read the entire file
f = open("demofile.txt", "r")
print("--- Full Content ---")
print(f.read())
f.close()

# Read only first 5 characters
f = open("demofile.txt", "r")
print("\n--- First 5 chars ---")
print(f.read(5))
f.close()
