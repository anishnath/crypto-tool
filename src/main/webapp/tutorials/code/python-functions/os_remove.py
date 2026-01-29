import os

# Create a test file
with open("deleteme.txt", "w") as f:
    f.write("This file will be deleted")

print("File created")

# Check if file exists
if os.path.exists("deleteme.txt"):
    print("File exists, deleting...")
    os.remove("deleteme.txt")
    print("File deleted!")

# Verify deletion
if not os.path.exists("deleteme.txt"):
    print("File successfully removed")
