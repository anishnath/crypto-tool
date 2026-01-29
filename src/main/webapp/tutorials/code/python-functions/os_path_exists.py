import os

# Check if file exists
if os.path.exists("demofile.txt"):
    print("File exists!")
else:
    print("File does not exist")

# Check if directory exists
if os.path.exists("/tmp"):
    print("Directory /tmp exists")

# Create a file and check again
with open("testfile.txt", "w") as f:
    f.write("test")

if os.path.exists("testfile.txt"):
    print("testfile.txt now exists!")
