import os

# Create a directory
try:
    os.mkdir("test_directory")
    print("Directory 'test_directory' created!")
except FileExistsError:
    print("Directory already exists")

# Check if it exists
if os.path.exists("test_directory"):
    print("Directory exists!")
